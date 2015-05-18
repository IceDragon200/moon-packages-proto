require 'data_model/metal'

module UI
  module Blendish
    class BaseTheme < Moon::DataModel::Metal
      # all fields should be initialized by default
      field_setting default: Moon::DataModel::Field.default_proc

      # Initializes a copy of the model.
      #
      # @param [Object] other  the original object to copy
      # @return [self]
      def initialize_copy(other)
        super
        other.each_field_with_value do |key, _, value|
          field_set key, value.safe_dup
        end
        self
      end
    end
  end
end
