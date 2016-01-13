require_relative 'expectation'

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

    def expect a_symbol
      unless @class_being_mocked.nil?
        unless @class_being_mocked.method_defined? a_symbol
          raise @class_being_mocked.name + ' does not implement the method: ' + a_symbol.to_s
        end
      end
      new_expectation = Expectation.new(a_symbol)
      @expectations.push(new_expectation)
      new_expectation
    end

    def nothing_was_called?
      @methods_called.empty?
    end

    def method_missing symbol, *args
      @methods_called.push(symbol)
      @expectations.each do
        |each_expectation|
        if each_expectation.method_symbol == symbol
          return each_expectation.was_called_with(args)
        end
      end
    end

    def respond_to? a_symbol
      unless @class_being_mocked.nil?
        return @class_being_mocked.method_defined? a_symbol
      end
      super a_symbol
    end

  end

end