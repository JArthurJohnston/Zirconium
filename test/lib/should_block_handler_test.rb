require_relative '../../test/zirconium_test_case'
require_relative '../../lib/mock_object'


module Zirconium

  class ShouldBlockHandlerTest < ZirconiumTestCase

    def test_mock_object_expects_expectation_block
      mock = MockObject.new
      mock.should do
        |mock|
        mock.method_we_should_expect
      end

      assert_equal 1, mock.expectations.size
      assert_equal :method_we_should_expect, mock.expectations[0].symbol
    end

    def test_expectation_block_handles_return_values
      mock = MockObject.new
      expected_return_value = 'some_value'
      mock.should do
        |mock|
        mock.method_we_should_expect.should_return expected_return_value
      end

      assert_equal 1, mock.expectations.size
      actual_expectation = mock.expectations[0]
      assert_equal :method_we_should_expect, actual_expectation.symbol
      assert_equal expected_return_value, actual_expectation.return_value
    end

    def test_expectation_block_handles_arguments
      mock = MockObject.new
      expected_return_value = 'some_value'
      expected_arguments = [:first_arg, :second_arg]
      mock.should do
        |mock|
        mock.method_we_should_expect(*expected_arguments).should_return expected_return_value
      end

      assert_equal 1, mock.expectations.size
      actual_expectation = mock.expectations[0]
      assert_equal :method_we_should_expect, actual_expectation.symbol
      assert_equal expected_return_value, actual_expectation.return_value
      assert_equal expected_arguments, actual_expectation.arguments
    end

  end

end