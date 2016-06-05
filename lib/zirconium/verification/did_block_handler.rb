module Zirconium
  class DidBlockHandler
    attr_reader :known_expectations,
                :suprises,
                :parent_mock

    def initialize(mock)
      @parent_mock = mock
      @known_expectations = mock.expectations
      @suprises = []
    end

    def method_missing symbol, *args
      expectation = Expectation.new(symbol, args)
      found_expectation = @parent_mock.find_expectation(expectation)
      if found_expectation.nil?
        @suprises.push(expectation)
        return expectation
      else
        return found_expectation
      end
    end

    def not_called_message_for an_expectation
      'the method ' + an_expectation.symbol.to_s + ' was not called'
    end

  end
end

