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
      unless method_valid? a_symbol
        raise @class_being_mocked.name + ' does not implement the method: ' + a_symbol.to_s
      end
      new_expectation = Expectation.new(a_symbol)
      @expectations.push(new_expectation)
      new_expectation
    end

    def method_valid? symbol
      unless @class_being_mocked.nil?
        unless @class_being_mocked.method_defined? symbol
          return false
        end
      end
      return true
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
        if each_expectation.method_symbol == symbol
          @methods_called.push(each_expectation)
          return each_expectation.was_called_with(args)
        end
      end
      unexpected_method = Expectation.new(symbol)
      unexpected_method.was_called_with(args)
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

  end

end