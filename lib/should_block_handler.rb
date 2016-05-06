require_relative 'expectation'

module Zirconium
  class ShouldBlockHandler
    attr_reader :expectations,
                :parent_mock

    def initialize(mock)
      @parent_mock = mock
      @expectations = []
    end

    def method_missing symbol, *args
      expectation = Expectation.new(symbol, args)
      @parent_mock.add_expectation(expectation)
      expectation
    end
  end

end