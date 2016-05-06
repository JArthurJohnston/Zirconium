require_relative 'expectation'
require_relative 'should_block_handler'
require_relative 'did_block_handler'

module Zirconium
  class MockObject
    attr_reader :expectations,
                :class_being_mocked,
                :methods_called

    def initialize class_being_mocked = nil
      @class_being_mocked = class_being_mocked
      @expectations = []
      @methods_called = []
    end

    def did &block
      handler = DidBlockHandler.new(self)
      block.call(handler)
      return handler.suprises.empty?

    end

    def should &block
      block.call(ShouldBlockHandler.new(self))
    end

    def add_expectation an_expectation
      @expectations.push an_expectation
    end

    def expect a_symbol
      unless method_valid? a_symbol
        raise @class_being_mocked.name + ' does not implement the method: ' + a_symbol.to_s
      end
      new_expectation = Expectation.new(a_symbol)
      @expectations.push(new_expectation)
      new_expectation
    end

    def method_named symbol
      return find_expectation_by_symbol symbol
    end

    def find_method_with symbol, *args
      expectation_to_find = Expectation.new(symbol, args)
      return find_expectation(expectation_to_find)
    end

    def methods_were_called?
      !@methods_called.empty?
    end

    def method_missing symbol, *args
      unless method_valid? symbol
        super(symbol, args)
      end
      @expectations.each do
        |each_expectation|
        if each_expectation.symbol == symbol
          @methods_called.push(each_expectation)
          return each_expectation.is_being_called_with(args)
        end
      end
      unexpected_method = Expectation.new(symbol)
      unexpected_method.is_being_called_with(args)
      @methods_called.push(unexpected_method)
    end

    def respond_to? a_symbol
      unless @class_being_mocked.nil?
        return @class_being_mocked.method_defined? a_symbol
      end
      super a_symbol
    end

    def to_s
      unless @class_being_mocked.nil?
        return @class_being_mocked.name + '(' + super + ')'
      end
      super
    end

    def find_expectation(expectation_to_find)
      @methods_called.each do
      |each_expectation|
        if each_expectation == expectation_to_find
          return each_expectation
        end
      end
      return nil
    end

    private

    def find_expectation_by_symbol symbol
      @methods_called.each do
        |each_expectation|
        if each_expectation.symbol == symbol
          return each_expectation
        end
      end
      return Expectation.new(nil)
    end

    def method_valid? symbol
      unless @class_being_mocked.nil?
        unless @class_being_mocked.method_defined? symbol
          return false
        end
      end
      return true
    end

  end

end