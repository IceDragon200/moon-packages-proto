require 'state_mvc/model_base'
require 'state_mvc/observable'

class State
  class ModelBinder < ModelBase
    include Moon::Eventable
    include Moon::Observable

    def pre_initialize
      super
      initialize_eventable
    end

    def self.delegate_attr(target, *args)
      args.each do |method_name|
        getter_name = method_name.to_sym
        setter_name = "#{method_name}=".to_sym
        define_method(getter_name) do
          send(target).send(getter_name)
        end
        define_method(setter_name) do |*a, &b|
          send(target).send(setter_name, *a, &b)
        end
      end
    end

    def self.bind_model_field(target, key)
      delegate_attr target, key
      observe_attr key
    end

    def self.bind_model(model, target = :model)
      field target, type: model
      model.each_field do |key, _|
        bind_model_field target, key
      end
    end
  end
end
