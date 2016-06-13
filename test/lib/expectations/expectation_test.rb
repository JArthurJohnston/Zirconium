require_relative '../../../test/zirconium_test_case'
require_relative '../../../lib/zirconium/expectations/expectation'

module Zirconium

  class ExpectationTest < ZirconiumTestCase

    def test_initialize
      expected = Expectation.new(:method_to_expect)

      assert_equal :method_to_expect, expected.symbol
      refute expected.called?
      assert_empty expected.arguments

      expected_args = ['arg1', 'arg2']
      expected2 = Expectation.new(:other_expectation, expected_args)

      assert_equal expected_args, expected2.arguments
    end

    def test_to_return
      expected = Expectation.new(nil)
      expected_return_value = 'the eventually returned value'
      expected.to_return expected_return_value

      assert_equal expected_return_value, expected.return_value
    end

    def test_call_and_return_with_nil_value
      expected = Expectation.new(nil)
      refute expected.called?

      returned_value = expected.is_being_called_with []

      assert expected.called?
      assert_nil returned_value
    end

    def test_call_and_return_with_a_value
      expected = Expectation.new(nil)
      refute expected.called?
      expected_value = 'some awesome value'
      expected.to_return expected_value

      actual_value = expected.is_being_called_with []

      assert expected.called?
      assert_equal expected_value, actual_value
      assert_equal [], expected.arguments
    end

    def test_was_called_with_args
      expected = Expectation.new(nil)
      arg_3 = Object.new
      arg_1 = 'arg1'
      arg_2 = :arg2
      expected.is_being_called_with [arg_1, arg_2, arg_3]

      assert expected.called?
      assert_equal [arg_1, arg_2, arg_3], expected.arguments
    end

    def test_called_with?
      expected = Expectation.new(nil)
      arg_3 = Object.new
      arg_1 = 'arg1'
      arg_2 = :arg2
      expected.is_being_called_with [arg_1, arg_2, arg_3]

      assert expected.called_with? arg_1, arg_2, arg_3

      refute expected.called_with? arg_3, arg_2, arg_1
      refute expected.called_with? arg_1, arg_2
      refute expected.called_with? 'some arg', 'some other arg'
    end

    def test_called_with_one_argument
      expected = Expectation.new(nil)
      arg_1 = 'arg1'
      expected.is_being_called_with [arg_1]

      assert expected.called_with? arg_1

      refute expected.called_with? nil
      refute expected.called_with? 'some arg'
    end

    def test_expectations_are_equal
      assert_all_equals Expectation.new(nil), Expectation.new(nil)
      assert_all_equals Expectation.new(:some_method), Expectation.new(:some_method)

      refute_all_equals Expectation.new(:some_method), Expectation.new(:some_other_method)

      assert_all_equals Expectation.new(nil, [1, 2]), Expectation.new(nil, [1, 2])
      assert_all_equals Expectation.new(:some_method, [2, 3]), Expectation.new(:some_method, [2, 3])

      refute_all_equals Expectation.new(:some_method, [3, 4]), Expectation.new(:some_other_method, [3, 4])
      refute_all_equals Expectation.new(:some_method, [3, 4]), Expectation.new(:some_method, [4, 5])
    end

    def test_expectation_with_anything_arg_is_equal_to_others
      assert_equal Expectation.new(nil, [Anything.new]), Expectation.new(nil, [nil])
      assert_equal Expectation.new(nil, [Anything.new, 2]), Expectation.new(nil, [1, 2])
      assert_equal Expectation.new(nil, [Anything.new, 2]), Expectation.new(nil, [Object.new, 2])
      assert_equal Expectation.new(nil, [Anything.new]), Expectation.new(nil, ["some string"])

      refute_equal Expectation.new(nil, [Anything.new]), Expectation.new(nil, [])
      refute_equal Expectation.new(nil, [Anything.new, 2]), Expectation.new(nil, [2])
    end

    def test_expectation_is_equal_to_expectation_with_anything
      assert_equal Expectation.new(nil, [nil]), Expectation.new(nil, [Anything.new])
      assert_equal Expectation.new(nil, [1, 2]), Expectation.new(nil, [Anything.new, 2])
      assert_equal Expectation.new(nil, [1, 2]), Expectation.new(nil, [1, Anything.new])
      assert_equal Expectation.new(nil, [Object.new, 2]), Expectation.new(nil, [Anything.new, 2])

      refute_equal Expectation.new(nil, []), Expectation.new(nil, [Anything.new])
      refute_equal Expectation.new(nil, [2]), Expectation.new(nil, [Anything.new, 2])
    end

    def test_to_s
      exp = Expectation.new(:something, [])
      assert_equal 'Expected Method something() not called', exp.to_s

      exp = Expectation.new(:something, [1, 2])
      assert_equal 'Expected Method something(1, 2) not called', exp.to_s

      exp = Expectation.new(:something, [1, 2])
      exp.was_called = true
      assert_equal 'Expected Method something(1, 2) was called', exp.to_s
    end

  end

end