require 'base/definition_proxy'

module SwiftlyPivotal
  module Smokestack

    @registry = {}

    def self.registry

      @registry

    end

    def self.define(&block)

      definition_proxy = SwiftlyPivotal::DefinitionProxy.new
      definition_proxy.instance_eval(&block)

    end

    def self.build(factory_class, overrides = {})

      instance   = SwiftlyPivotal.const_get(factory_class.capitalize).new
      factory    = registry[SwiftlyPivotal.const_get(factory_class.capitalize)]
      attributes = factory.attributes.merge(overrides)

      attributes.each do |attribute_name, value|

        instance.send("#{attribute_name}=", value)

      end

      instance

    end
  end
end