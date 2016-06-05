
module Zirconium

  class MethodStub
    attr_reader :symbol,
                :original,
                :original_owner,
                :behavior

    def initialize symbol
      @symbol = symbol
      @arguments_passed_in = []
      @behavior = lambda do
        |*args|
        @arguments_passed_in = args
        return nil
      end
    end

    def called_with? *args
      @arguments_passed_in == args
    end

    def on an_object
      @original_owner = an_object
      @original = an_object.method(@symbol)
      self
    end

    def to_return an_object
      @behavior = lambda do
        |*args|
        @arguments_passed_in = args
        return an_object
      end
      self
    end

    def to_perform block
      # unless @original.nil?
      #   if block.arity != @original.arity
      #     raise 'stub block has the incorrect number of arguments'
      #   end
      # end
      # dont know if this is necessary. Its cool though
      @behavior = block
      self
    end

    def replace
      replace_behavior_with @behavior
    end

    def restore
      replace_behavior_with @original
    end

    private

    def replace_behavior_with a_block
      @original_owner.class.send(:define_method, @symbol) do
        |*args|
        a_block.call *args
      end
    end


  end

end
