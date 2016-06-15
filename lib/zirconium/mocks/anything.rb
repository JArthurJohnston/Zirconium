module Zirconium

  class Anything
    attr_reader :mocked_class

    def initialize mocked_class = nil
      @mocked_class = mocked_class
    end

    def that_is a_class
      @mocked_class = a_class
    end
    
    def eql? other
      if @mocked_class.nil?
        return true
      elsif other.kind_of? self.class
        return self.mocked_class == other.mocked_class
      else
        return other.kind_of? @mocked_class
      end
    end

    def == other
      eql? other
    end

    def hash
      @mocked_class.hash
    end
  end


end