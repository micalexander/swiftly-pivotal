require "base/smokestack"
require "base/factory"

module SwiftlyPivotal
  class DefinitionProxy

    def factory(factory_class, &block)

      factory = SwiftlyPivotal::Factory.new

      factory.instance_eval(&block)

      Smokestack.registry[SwiftlyPivotal.const_get(factory_class.capitalize)] = factory

    end
  end
end