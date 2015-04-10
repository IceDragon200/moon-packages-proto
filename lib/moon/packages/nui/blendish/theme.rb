require 'nui/blendish/base_theme'
require 'nui/blendish/widget_theme'
require 'nui/blendish/node_theme'

module UI
  module Blendish
    class Theme < BaseTheme
      field :background_color,   type: NVG::Color
      field_setting type: WidgetTheme do
        field :regular_theme
        field :tool_theme
        field :radio_theme
        field :text_field_theme
        field :option_theme
        field :choice_theme
        field :number_field_theme
        field :slider_theme
        field :scroll_bar_theme
        field :tooltip_theme
        field :menu_theme
        field :menu_item_theme
      end
      field :node_theme,         type: NodeTheme
    end
  end
end
