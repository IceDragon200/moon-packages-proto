require 'nui/blendish/theme'

module UI
  module BNDThemes
    class << self
      attr_accessor :default
      # based on the bitwig studio UI
      attr_accessor :twig
    end

    def self.init
      self.default = UI::Blendish::Theme.new.tap do |t|
        # some global settings
        bnd_color_text = NVG.rgbaf(0, 0, 0, 1)
        bnd_color_text_selected = NVG.rgbaf(1, 1, 1, 1)

        # background_color
        t.background_color.set(0.447, 0.447, 0.447, 1.0)

        # regular_theme
        t.regular_theme.tap do |w|
          w.outline_color.set(0.098, 0.098, 0.098, 1)
          w.item_color.set(0.098, 0.098, 0.098, 1)
          w.inner_color.set(0.6, 0.6, 0.6, 1)
          w.inner_selected_color.set(0.392, 0.392, 0.392, 1)
          w.text_color = bnd_color_text
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = 0
          w.shade_down = 0
        end

        # tool_theme
        t.tool_theme.tap do |w|
          w.outline_color.set(0.098, 0.098, 0.098, 1)
          w.item_color.set(0.098, 0.098, 0.098, 1)
          w.inner_color.set(0.6, 0.6, 0.6, 1)
          w.inner_selected_color.set(0.392, 0.392, 0.392, 1)
          w.text_color = bnd_color_text
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = 15
          w.shade_down = -15
        end

        # radio_theme
        t.radio_theme.tap do |w|
          w.outline_color.set(0, 0, 0, 1)
          w.item_color.set(1, 1, 1, 1)
          w.inner_color.set(0.275, 0.275, 0.275, 1)
          w.inner_selected_color.set(0.337, 0.502, 0.761, 1)
          w.text_color = bnd_color_text_selected
          w.text_selected_color = bnd_color_text
          w.shade_top = 15
          w.shade_down = -15
        end

        # text_field_theme
        t.text_field_theme.tap do |w|
          w.outline_color.set(0.098, 0.098, 0.098, 1)
          w.item_color.set(0.353, 0.353, 0.353, 1)
          w.inner_color.set(0.6, 0.6, 0.6, 1)
          w.inner_selected_color.set(0.6, 0.6, 0.6, 1)
          w.text_color = bnd_color_text
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = 0
          w.shade_down = 25
        end

        # option_theme
        t.option_theme.tap do |w|
          w.outline_color.set(0, 0, 0, 1)
          w.item_color.set(1, 1, 1, 1)
          w.inner_color.set(0.275, 0.275, 0.275, 1)
          w.inner_selected_color.set(0.275, 0.275, 0.275, 1)
          w.text_color = bnd_color_text
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = 15
          w.shade_down = -15
        end

        # choice_theme
        t.choice_theme.tap do |w|
          w.outline_color.set(0, 0, 0, 1)
          w.item_color.set(1, 1, 1, 1)
          w.inner_color.set(0.275, 0.275, 0.275, 1)
          w.inner_selected_color.set(0.275, 0.275, 0.275, 1)
          w.text_color = bnd_color_text_selected
          w.text_selected_color.set(0.8, 0.8, 0.8, 1)
          w.shade_top = 15
          w.shade_down = -15
        end

        # number_field_theme
        t.number_field_theme.tap do |w|
          w.outline_color.set(0.098, 0.098, 0.098, 1)
          w.item_color.set(0.353, 0.353, 0.353, 1)
          w.inner_color.set(0.706, 0.706, 0.706, 1)
          w.inner_selected_color.set(0.6, 0.6, 0.6, 1)
          w.text_color = bnd_color_text
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = -20
          w.shade_down = 0
        end

        # slider_theme
        t.slider_theme.tap do |w|
          w.outline_color.set(0.098, 0.098, 0.098, 1)
          w.item_color.set(0.502, 0.502, 0.502, 1)
          w.inner_color.set(0.706, 0.706, 0.706, 1)
          w.inner_selected_color.set(0.6, 0.6, 0.6, 1)
          w.text_color = bnd_color_text
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = -20
          w.shade_down = 0
        end

        # scroll_bar_theme
        t.scroll_bar_theme.tap do |w|
          w.outline_color.set(0.196, 0.196, 0.196, 1)
          w.item_color.set(0.502, 0.502, 0.502, 1)
          w.inner_color.set(0.314, 0.314, 0.314, 0.706)
          w.inner_selected_color.set(0.392, 0.392, 0.392, 0.706)
          w.text_color = bnd_color_text
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = 5
          w.shade_down = -5
        end

        # tooltip_theme
        t.tooltip_theme.tap do |w|
          w.outline_color.set(0, 0, 0, 1)
          w.item_color.set(0.392, 0.392, 0.392, 1)
          w.inner_color.set(0.098, 0.098, 0.098, 0.902)
          w.inner_selected_color.set(0.176, 0.176, 0.176, 0.902)
          w.text_color.set(0.627, 0.627, 0.627, 1)
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = 0
          w.shade_down = 0
        end

        # menu_theme
        t.menu_theme.tap do |w|
          w.outline_color.set(0, 0, 0, 1)
          w.item_color.set(0.392, 0.392, 0.392, 1)
          w.inner_color.set(0.098, 0.098, 0.098, 0.902)
          w.inner_selected_color.set(0.176, 0.176, 0.176, 0.902)
          w.text_color.set(0.627, 0.627, 0.627, 1)
          w.text_selected_color = bnd_color_text_selected
          w.shade_top = 0
          w.shade_down = 0
        end

        # menu_item_theme
        t.menu_item_theme.tap do |w|
          w.outline_color.set(0, 0, 0, 1)
          w.item_color.set(0.675, 0.675, 0.675, 1)
          w.inner_color.set(0, 0, 0, 0)
          w.inner_selected_color.set(0.337, 0.502, 0.761, 1)
          w.text_color = bnd_color_text_selected
          w.text_selected_color =  bnd_color_text
          w.shade_top = 38
          w.shade_down = 0
        end

        # node_theme
        t.node_theme.tap do |n|
          n.node_selected_color.set(0.945, 0.345, 0, 1)
          n.wires_color.set(0, 0, 0, 1)
          n.text_selected_color.set(0.498, 0.439, 0.439, 1)
          n.active_node_color(1, 0.667, 0.251, 1)
          n.wire_select_color.set(1, 1, 1, 1)
          n.node_backdrop_color.set(0.608, 0.608, 0.608, 0.627)
          n.noodle_curving = 5
        end
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
end
