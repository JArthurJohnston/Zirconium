module Zirconium

  class Expectation
    attr_reader :method_symbol,
                :return_value,
                :arguments_passed_in

    def initialize expected_method_symbol
      @method_symbol = expected_method_symbol
      @was_called = false
      @arguments_passed_in = []
    end

    def to_return an_object
      @return_value = an_object
    end

    def called?
      @was_called
    end

    def was_called_with *args
      @arguments_passed_in = args
      @was_called = true
      @return_value
    end

  end

end