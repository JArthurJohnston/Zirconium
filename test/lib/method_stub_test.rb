require_relative '../zirconium_test_case'
require_relative '../../lib/zirconium/mocks/method_stub'

module Zirconium

    class MethodStubTest < ZirconiumTestCase

      class ClassToStubOn
        def method_to_stub_out
          return 'not stubbed value'
        end

        def method_to_stub_with_args arg1, arg2
          return arg1.to_s + ' ' + arg2.to_s + ' not stubbed'
        end
      end
    
      def test_initialize
        stub = MethodStub.new :test_method_symbol

        assert_equal :test_method_symbol, stub.symbol
        assert_nil stub.original
        assert_nil stub.original_owner
        assert_nil stub.behavior.call
      end

      def test_stub_method_on_saves_original_method
        method_owner = ClassToStubOn.new
        stub = MethodStub.new(:method_to_stub_out).on(method_owner)
        assert_type MethodStub, stub

        expected_original = method_owner.method(:method_to_stub_out)
        assert_equal expected_original, stub.original
      end

      def test_to_return_sets_behavior
        stub = MethodStub.new nil
        expected_ret_value = 'test value'
        stub.to_return expected_ret_value

        assert_equal expected_ret_value, stub.behavior.call
        assert_empty stub.instance_variable_get(:@arguments_passed_in)

        assert_equal expected_ret_value, stub.behavior.call('one', 'three')
        assert_equal ['one', 'three'], stub.instance_variable_get(:@arguments_passed_in)
        assert stub.called_with?('one', 'three')
      end

      def test_on_to_return_to_perform_all_return_self
        stub = MethodStub.new :to_s
        obj_to_stub = Object.new

        on_stub = stub.on(obj_to_stub)

        assert_same stub, on_stub

        ret_val_stub = stub.to_return('hahahaha')

        assert_same stub, ret_val_stub

        perform_stub = stub.to_perform lambda {return 'skfljsdlkfj'}

        assert_same perform_stub, stub

      end

      def test_to_perform_sets_behavior
        stub = MethodStub.new nil
        test_value = false
        new_behavior = lambda {test_value = true}

        stub.to_perform new_behavior
        stub.behavior.call

        assert test_value
      end

      def test_initial_behavior_accepts_args
        stub = MethodStub.new nil
        stub.behavior.call('one', 'two')

        assert stub.called_with?('one', 'two')
      end

      def test_replace_and_restore
        original = ClassToStubOn.new
        stub = MethodStub.new :method_to_stub_out
        stub.on original
        expected_ret_value = 'stubbed return value'
        stub.to_return expected_ret_value

        stub.replace

        assert_equal expected_ret_value, original.method_to_stub_out

        stub.restore
        assert_equal 'not stubbed value', original.method_to_stub_out
      end

      def test_replace_captures_arguments
        original = ClassToStubOn.new
        stub = MethodStub.new :method_to_stub_with_args
        stub.on original
        expected_ret_value = 'stubbed return value'
        stub.to_return expected_ret_value

        stub.replace

        assert_equal expected_ret_value, original.method_to_stub_with_args('one', 'two')
        assert stub.called_with?('one', 'two')

        stub.restore

        assert_equal 'one two not stubbed', original.method_to_stub_with_args('one', 'two')
      end

      # def test_to_perform_raises_error_when_behavior_arrity_doesnt_match_original_arrity
      #   original_owner = ClassToStubOn.new
      #   stub = MethodStub.new :method_to_stub_with_args
      #   stub.on original_owner
      #
      #   assert_raises RuntimeError do
      #     stub.to_perform lambda {return 'should throw an error'}
      #   end
      # end
  
    end
end