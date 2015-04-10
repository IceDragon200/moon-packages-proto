require 'nui/blendish/theme'

module UI
  module BNDThemes
    class << self
      attr_accessor :default
      # based on the bitwig studio UI
      attr_accessor :twig
    end

    self.default = UI::Blendish::Theme.new.tap do |t|
    end

    self.twig = UI::Blendish::Theme.new.tap do |t|
      outline_color = NVG.rgb(22, 22, 22)
      item_color = outline_color
      inner_color = NVG.rgb(66, 66, 66)
      inner_selected_color = NVG.rgb(209, 85, 18)
      background_color = NVG.rgb(58, 58, 58)
      widget_background_color = NVG.rgb(68, 68, 68)
      text_color_active = NVG.rgb(178, 178, 178)
      text_color_inactive = NVG.rgb(118, 118, 118)
      text_selected_color = NVG.rgb(18, 18, 18)
      shade_top = 7
      shade_down = 0

      t.background_color = background_color
      t.regular_theme.tap do |w|
        w.outline_color = outline_color
        w.item_color = item_color
        w.inner_color = inner_color
        w.inner_selected_color = inner_selected_color
        w.text_color = text_color_active
        w.text_selected_color = text_selected_color
        w.shade_top = shade_top
        w.shade_down = shade_down
      end

      t.tool_theme = t.regular_theme.dup
      t.radio_theme = t.regular_theme.dup
      t.text_field_theme = t.regular_theme.dup
      t.option_theme = t.regular_theme.dup
      t.choice_theme = t.regular_theme.dup
      t.number_field_theme = t.regular_theme.dup
      t.slider_theme = t.regular_theme.dup
      t.scroll_bar_theme = t.regular_theme.dup
      t.tooltip_theme = t.regular_theme.dup
      t.menu_theme = t.regular_theme.dup
      t.menu_item_theme = t.regular_theme.dup

      t.node_theme.tap do |w|
      end
    end
  end
end
