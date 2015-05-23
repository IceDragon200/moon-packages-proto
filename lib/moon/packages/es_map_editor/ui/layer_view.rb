module ES
  module UI
    class MapEditorLayerView < Moon::RenderContext
      attr_accessor :index
      attr_accessor :layer_count

      def init
        super
        @layer_ss = Moon::Sprite.new(TextureCache.ui('hud_mockup.png'))
        @layer_count = 2
        @index = -1
      end

      def w
        @w ||= @layer_ss.w * 4
      end

      def h
        @h ||= @layer_ss.h
      end

      def render_content(x, y, z, options)
        @layer_ss.clip_rect = Moon::Rect.new(144, 80, 16, 40)
        case @index
        when -1
        when 0
          @layer_ss.clip_rect = @layer_ss.clip_rect.translatef(1, 0)
        when 1
          @layer_ss.clip_rect = @layer_ss.clip_rect.translatef(2, 0)
        when 2
          @layer_ss.clip_rect = @layer_ss.clip_rect.translatef(3, 0)
        end
        @layer_ss.render x, y, z
      end
    end
  end
end
