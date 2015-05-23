module ES
  module UI
    class IconButton < Moon::RenderContext
      attr_accessor :icon_sprite

      def initialize_content
        super
        @icon_sprite = nil
        @label_text = Moon::Text.new '', FontCache.font('system', 16)
      end

      def color
        @icon_sprite.color
      end

      def color=(color)
        @icon_sprite.color = color
      end

      def label
        @label_text.string
      end

      def label=(label)
        @label_text.string = label
      end

      def w
        @icon_sprite.w
      end

      def h
        @icon_sprite.h
      end

      def render_content(x, y, z, options)
        @icon_sprite.render x, y, z
        @label_text.render x, y + h, z
      end
    end
  end
end
