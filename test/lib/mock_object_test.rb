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
      assert mock.nothing_was_called?
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
      assert_equal :production_called_a_method, mock.methods_called[0]
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
      assert_equal :method_to_mock_out, mock.methods_called[0]
    end
  end

end