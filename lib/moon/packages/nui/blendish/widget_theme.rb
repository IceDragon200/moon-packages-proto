require 'nui/blendish/base_theme'

module UI
  module Blendish
    class WidgetTheme < BaseTheme
      field_setting type: NVG::Color do
        field :outline_color
        field :item_color
        field :inner_color
        field :inner_selected_color
        field :text_color
        field :text_selected_color
      end

      field_setting type: Numeric do
        field :shade_top
        field :shade_down
      end
    end
  end
end
