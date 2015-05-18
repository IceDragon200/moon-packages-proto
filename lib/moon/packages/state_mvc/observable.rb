require 'std/event'

module Moon
  module Observable
    class ObservedChange < Moon::Event
      attr_accessor :obj
      attr_accessor :name
      attr_accessor :old
      attr_accessor :cur

      def initialize(obj, name, old, cur)
        @obj = obj
        @name = name
        @old = old
        @cur = cur
        super :changed
      end
    end

    module ClassMethods
      def observe_attr(name)
        setter_name = "#{name}=".to_sym
        unobserved_setter_name = "unobserved_#{setter_name}".to_sym
        alias_method unobserved_setter_name, setter_name
        define_method(setter_name) do |*args, &block|
          old = send(name)
          send(unobserved_setter_name, *args, &block)
          trigger { ObservedChange.new self, name, old, send(name) }
        end
      end
    end

    include Moon::Eventable

    def self.included(mod)
      mod.extend ClassMethods
    end
  end
end
