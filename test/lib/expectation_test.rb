require_relative '../../test/zirconium_test_case'
require_relative '../../lib/expectation'

module Zirconium

  class ExpectationTest < ZirconiumTestCase

    def test_initialize
      expected = Expectation.new(:method_to_expect)

      assert_equal :method_to_expect, expected.method_symbol
      refute expected.called?
      assert_empty expected.arguments_passed_in
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

      returned_value = expected.was_called_with

      assert expected.called?
      assert_nil returned_value
    end

    def test_call_and_return_with_a_value
      expected = Expectation.new(nil)
      refute expected.called?
      expected_value = 'some awesome value'
      expected.to_return expected_value

      actual_value = expected.was_called_with

      assert expected.called?
      assert_equal expected_value, actual_value
      assert_equal [], expected.arguments_passed_in
    end

    def test_was_called_with_args
      expected = Expectation.new(nil)
      arg_3 = Object.new
      arg_1 = 'arg1'
      arg_2 = :arg2
      expected.was_called_with arg_1, arg_2, arg_3

      assert expected.called?
      assert_equal [arg_1, arg_2, arg_3], expected.arguments_passed_in
    end
  end

end