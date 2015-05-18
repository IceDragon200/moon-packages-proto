require 'render_primitives/render_context'

module ES
  module UI
    class TilePreview < Moon::RenderContext
      attr_reader :tile_id       # Integer
      # @return [Moon::Spritesheet]
      attr_reader :tileset

      def initialize
        super
        texture = TextureCache.block 'e008x008.png'
        @micro_ss = Moon::Spritesheet.new texture, 8, 8
        texture = TextureCache.block 'e064x064.png'
        @background_ss = Moon::Spritesheet.new texture, 64, 64

        @text = AnimatedText.new '', FontCache.font('uni0553', 16)

        self.tile_id = -1
        self.tileset = nil
      end

      def tileset=(tileset)
        @tileset = tileset
        resize(nil, nil)
      end

      def tile_id=(tile_id)
        old = @tile_id
        @tile_id = tile_id

        if @tile_id != old
          @old_tile_id = old
          @text.set(string: "Tile #{@tile_id}")
          @text.arm(0.5)
        end
      end

      def w
        @w ||= @background_ss.cell_w
      end

      def h
        @h ||= @background_ss.cell_h
      end

      def update_content(delta)
        @text.update delta
        super
      end

      def render_content(x, y, z, options)
        @background_ss.render x, y, z, 1

        if @tileset
          diff = (@background_ss.cell_size - @tileset.cell_size) / 2

          if @text.done?
            if @tile_id >= 0
              @tileset.render diff.x + x, diff.y + y, z, @tile_id
            end
          else
            r = @text.time / @text.duration
            if @tile_id >= 0
              @tileset.render diff.x + x, diff.y + y, z, @tile_id, opacity: r
            end
            if @old_tile_id >= 0
              @tileset.render diff.x + x, diff.y + y, z, @old_tile_id, opacity: 1-r
            end
          end

          dx = (@background_ss.cell_w - @text.w) / 2
          @text.render dx + x,
                       diff.y + y + @tileset.cell_h - 4,
                       z
        else
          @micro_ss.render x, y, z, 8
        end
        super
      end
    end
  end
end
