require_relative '../../../test/zirconium_test_case'
require_relative '../../../lib/zirconium/mocks/mock_object'

module Zirconium

  class DidBlockHandlerTest < ZirconiumTestCase

    def test_verifies_method_was_called
      mock = MockObject.new

      mock.should do
      |expect|
        expect.method_that_will_get_called
        expect.method_that_wont_get_called
      end

      mock.method_that_will_get_called

      assert(mock.did do
      |check|
        check.method_that_will_get_called
      end)
    end

    def test_fails_when_method_wasnt_called
      mock = MockObject.new

      mock.did do
        |check|
        refute check.fail_cuz_this_method_wasnt_called.was_called?
      end

    end

    def test_handler_returns_expectation
      mock = MockObject.new
      mock.method_that_was_called

      mock.did do
        |check|
        refute check.method_that_wasnt_called.called?
        assert check.method_that_was_called.called?
      end

      mock.another_called_method('one', 'two')

      mock.did do
        |check|
        assert check.another_called_method('one', 'two').called?
        refute check.another_called_method('three', 'four').called?
      end

    end

    def test_initialize
      mock = MockObject.new
      expected_expectation = Expectation.new(:one)
      mock.add_expectation(expected_expectation)

      handler = DidBlockHandler.new(mock)

      assert_same(mock, handler.parent_mock)
      assert_equal 1, handler.known_expectations.size
      assert handler.known_expectations.include?(expected_expectation)
    end
  end

end