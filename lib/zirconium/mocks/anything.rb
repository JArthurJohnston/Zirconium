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
      if other.nil? || @mocked_class.nil?
        return true
      else
        return @mocked_class == other.mocked_class
      end
    end

    def == other
      eql? other
    end

    def hash
      @mocked_class.hash
    end
  end

  ANYTHING = :literally_anything

  def any_object
    return ANYTHING
  end

end