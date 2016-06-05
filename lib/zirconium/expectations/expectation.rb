require_relative '../../../lib/zirconium/mocks/anything'
require_relative 'expectation_string'

module Zirconium

  class Expectation
    include ExpectationString

    attr_reader :symbol,
                :return_value,
                :arguments

    def initialize expected_method_symbol, arguments = []
      @symbol = expected_method_symbol
      @arguments = arguments
      @was_called = false
    end

    def to_return an_object
      @return_value = an_object
    end

    def should_return an_object
      to_return an_object
    end

    def called?
      @was_called
    end

    def was_called= a_boolean
      @was_called = a_boolean
    end

    def called_with? *args
      @was_called and @arguments.eql?(args)
    end

    def is_being_called_with list_of_args
      @arguments = list_of_args
      @was_called = true
      @return_value
    end

    def == other_expectation
      @symbol == other_expectation.symbol and
          args_are_equal?(other_expectation.arguments)
    end

    def args_are_equal?(arguments)
      if @arguments.size == arguments.size
        for i in 0..arguments.size
          current_arg = @arguments[i]
          other_arg = arguments[i]
          if current_arg == ANYTHING || other_arg == ANYTHING
            return true
          end
          if current_arg != other_arg
            return false
          end
        end
      else
        return false
      end
      return true
    end

    def eql? other_expectation
      self == other_expectation
    end

    def hash
      [@symbol, @arguments].hash
    end

  end

end