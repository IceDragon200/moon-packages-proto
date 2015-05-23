require 'render_primitives/render_container'
require 'es_map_editor/ui/icon_button'

module ES
  module UI
    class MapEditorDashboard < Moon::RenderContainer
      attr_accessor :default_color

      def initialize
        super
        pal = DataCache.palette
        @default_color = pal['white']
        @info_color    = pal['system/info']
        @ok_color      = pal['system/ok']
        @warning_color = pal['system/warning']
        @error_color   = pal['system/error']

        @help       = add_button 'book-question',        'F1'        # F1  # 0
        @new_map    = add_button 'map--plus',            'F2'        # F2  # 1
        @new_chunk  = add_button 'zone--plus',           'F3'        # F3  # 2
        @reserved4  = add_button 'blank',                'F4'        # F4  # 3
        @save_map   = add_button 'disk-black',           'F5'        # F5  # 4
        @load_map   = add_button 'folder-open-document', 'F6'        # F6  # 5
        @reserved7  = add_button 'blank',                'F7'        # F7  # 6
        @grid       = add_button 'border',               'F8'        # F8  # 7
        @keyboard   = add_button 'keyboard-space',       'F9'        # F9  # 8
        @show_chunk = add_button 'ui-tooltip',           'F10'       # F10 # 9
        @edit       = add_button 'wrench',               'F11'       # F11 # 11
        @reserved12 = add_button 'blank',                'F12'       # F12 # 10

        disable
      end

      def add_button(icon_name, label = '')
        button = IconButton.new
        button.icon_sprite = Moon::Sprite.new(TextureCache.resource("icons/map_editor/2x/#{icon_name}_2x.png"))
        button.label = label
        button.position = Moon::Vector3.new(@elements.size * (button.w + 16), 0, 0)
        add button
        button
      end

      def state(color, index = nil)
        if index
          @elements[index].transition(:color, color, 0.15)
        else
          @elements.each { |e| e.color.set color }
        end
      end

      def info(index = nil)
        state @info_color, index
      end

      def ok(index = nil)
        state @ok_color, index
      end

      def error(index = nil)
        state @error_color, index
      end

      def warning(index = nil)
        state @warning_color, index
      end

      def disable(index = nil)
        state @default_color, index
      end

      def toggle(index, bool)
        bool ? enable(index) : disable(index)
      end

      alias :enable :ok
    end
  end
end
