require_relative '../../test/zirconium_test_case'
require_relative '../../lib/expectation'

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
      assert_overode_equals Expectation.new(nil), Expectation.new(nil)
      assert_overode_equals Expectation.new(:some_method), Expectation.new(:some_method)

      refute_overrode_equals Expectation.new(:some_method), Expectation.new(:some_other_method)

      assert_overode_equals Expectation.new(nil, [1, 2]), Expectation.new(nil, [1, 2])
      assert_overode_equals Expectation.new(:some_method, [2, 3]), Expectation.new(:some_method, [2, 3])

      refute_overrode_equals Expectation.new(:some_method, [3, 4]), Expectation.new(:some_other_method, [3, 4])
      refute_overrode_equals Expectation.new(:some_method, [3, 4]), Expectation.new(:some_method, [4, 5])
    end
  end

end