require 'std/event'

module Moon
  module Observable
    class ObservedChange < Moon::Event
      attr_accessor :obj
      attr_accessor :attribute
      attr_accessor :old_value
      attr_accessor :value

      def initialize(obj, attribute, old_value, value)
        @obj = obj
        @attribute = attribute
        @old_value = old_value
        @value = value
        super :changed
      end
    end

    module ClassMethods
      extend Moon::Prototype

      prototype_attr :observed_property

      def observe_attr(name)
        observed_properties << name.to_sym
        setter_name = "#{name}=".to_sym
        unobserved_setter_name = "unobserved_#{setter_name}".to_sym
        alias_method unobserved_setter_name, setter_name
        define_method(setter_name) do |*args, &block|
          old = send(name)
          send(unobserved_setter_name, *args, &block)
          notify(name, old)
        end
      end
    end

    include Moon::Eventable

    def notify(attribute, old)
      trigger { ObservedChange.new self, attribute, old, send(attribute) }
    end

    def notify_all
      self.class.each_observed_property do |key|
        notify(key, nil)
      end
    end

    def self.included(mod)
      mod.extend ClassMethods
    end
  end
end
