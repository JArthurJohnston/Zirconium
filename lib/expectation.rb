module Zirconium

  class Expectation
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
          @arguments == other_expectation.arguments
    end

    def eql? other_expectation
      self == other_expectation
    end

    def hash
      [@symbol, @arguments].hash
    end

  end

end