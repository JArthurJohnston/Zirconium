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

    def was_called?
      @was_called
    end

    def was_called= a_boolean
      @was_called = a_boolean
    end

    def called_with? *args
      @was_called and @arguments.eql?(args)
    end

    def is_being_called_with list_of_args
      unless args_are_equal?(list_of_args)
        @arguments = list_of_args
      end
      @was_called = true
      @return_value
    end

    def == other_expectation
      @symbol == other_expectation.symbol and
          args_are_equal?(other_expectation.arguments)
    end

    def args_are_equal?(arguments)
      unless @arguments.size == arguments.size
        return false
      end
      if @arguments.empty?
        return true
      end
      for i in 0..@arguments.size - 1
        this_arg = @arguments[i]
        other_arg = arguments[i]
        if is_any_arg(this_arg, other_arg)
          break
        elsif this_arg != other_arg
          return false
        end
      end
      return true
    end

    def is_any_arg(this_arg, that_arg)
      if this_arg.is_a? Anything
        return this_arg == that_arg
      elsif that_arg.is_a? Anything
        return that_arg == this_arg
      end
      return false
    end

    def eql? other_expectation
      self == other_expectation
    end

    def hash
      [@symbol, @arguments].hash
    end

  end

end