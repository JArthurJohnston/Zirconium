require_relative '../../test/zirconium_test_case'
require_relative '../../lib/mock_object'

module Zirconium
  class MockObjectTest < ZirconiumTestCase

    class ClassToMockOut
      def method_to_mock_out
        return 'totally not a mock method'
      end
    end

    def test_initialize
      mock = MockObject.new

      assert_empty mock.expectations
      assert_nil mock.class_being_mocked
      assert_empty mock.methods_called
      refute mock.methods_were_called?
    end

    def test_expect
      mock = MockObject.new
      assert_empty mock.expectations

      mock.expect(:something_to_expect)

      assert_equal 1, mock.expectations.length
      assert_equal :something_to_expect, mock.expectations[0].method_symbol
    end

    def test_call_method_adds_to_methods_called
      mock = MockObject.new

      mock.production_called_a_method

      assert_equal 1, mock.methods_called.length
      expected_expectation = Expectation.new(:production_called_a_method)
      assert_equal expected_expectation, mock.methods_called[0]
      refute mock.respond_to? :production_called_a_method
    end

    def test_mock_responds_to_what_its_mocking
      mock = MockObject.new ClassToMockOut

      assert mock.respond_to? :method_to_mock_out
    end

    def test_mock_responds_to_Object_methods
      mock = MockObject.new
      assert mock.respond_to? :trust
      assert mock.respond_to? :eql?
      assert mock.respond_to? :==

      refute mock.respond_to? :method_to_mock_out
    end

    def test_mock_object_throws_error_when_expecting_nonexistent_method
      mock = MockObject.new ClassToMockOut

      assert_empty mock.expectations

      assert_raises RuntimeError do
        mock.expect :method_that_isnt_implemented_on_mocked_class
      end

      assert_empty mock.expectations

      mock.expect :method_to_mock_out

      assert_equal 1, mock.expectations.length
    end

    def test_mock_returns_expected_value_when_mocked_method_called
      mock = MockObject.new ClassToMockOut
      returned_value = 'mocked out value to return'
      mock.expect(:method_to_mock_out).to_return(returned_value)

      assert_empty mock.methods_called
      assert_equal returned_value, mock.method_to_mock_out
      assert_equal 1, mock.methods_called.length
      expected_expectation = Expectation.new(:method_to_mock_out)
      assert_equal expected_expectation, mock.methods_called[0]
    end

    def test_calling_unimplemented_method_throws_error
      mock = MockObject.new ClassToMockOut

      assert_raises NoMethodError do
        mock.some_method_that_hasnt_been_implemented
      end
    end

    def test_mock_object_to_s_includes_mocked_class_name
      mock1 = MockObject.new

      refute mock1.to_s.include?('ClassToMockOut')

      mock2 = MockObject.new ClassToMockOut
      assert mock2.to_s.include?('ClassToMockOut')
    end

    def test_method_named
      mock = MockObject.new
      empty_expectation = mock.method_named(:method_that_wasnt_called)

      assert_nil empty_expectation.method_symbol
      refute empty_expectation.called?

      mock.called_a_method

      assert_equal 1, mock.methods_called.length
      called_expectation = mock.method_named :called_a_method

      assert_equal :called_a_method, called_expectation.method_symbol
      assert called_expectation.called?
    end

    def test_method_missing_passes_args_to_expectation
      mock = MockObject.new

      mock.method_to_call('args', 'to', 'pass')

      assert mock.method_named(:method_to_call).called_with?('args', 'to', 'pass')

      mock.another_method_to_call('only 1 arg')

      assert mock.method_named(:another_method_to_call).called_with?('only 1 arg')
    end
  end

end