require 'nui/blendish/base_theme'

module UI
  module Blendish
    class NodeTheme < BaseTheme
      field_setting type: NVG::Color do
        field :node_selected_color
        field :wires_color
        field :text_selected_color
        field :active_node_color
        field :wire_select_color
        field :node_backdrop_color
      end
      field :noodle_curving, type: Integer
    end
  end
end
