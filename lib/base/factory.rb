module SwiftlyPivotal
  class Factory < BasicObject

    attr_reader :attributes

    def initialize

      @attributes = {}

    end

    def method_missing(name, *args, &block)

      @attributes[name] = args[0]

    end
  end
end