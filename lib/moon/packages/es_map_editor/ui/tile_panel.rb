module ES
  module UI
    class TilePanel < Moon::RenderContext
      # @return [Moon::Spritesheet]
      attr_reader :tileset

      # @return [Integer]
      attr_reader :tile_id

      # @return [Integer]
      attr_accessor :visible_cols

      # @return [Integer]
      attr_accessor :visible_rows

      def pre_initialize
        super
        @tileset = nil # spritesheet
        @visible_rows = 8
        @visible_cols = 8

        @tilesize = Moon::Vector2.new 32, 32
        @cursor = Cursor2.new
        @cursor.position = Moon::Vector2.new 0, 0

        @text = Moon::Text.new '', FontCache.font('uni0553', 16)

        texture = TextureCache.block 'e032x032.png'
        @block_ss = Moon::Spritesheet.new texture, 32, 32

        background_texture = TextureCache.ui 'hud_mockup_4x.png'
        @background_s = Moon::Sprite.new background_texture
        @background_s.clip_rect = Moon::Rect.new 24, 216, 272, 272
        @scroll_bar = Moon::Sprite.new background_texture
        @scroll_bar.clip_rect = Moon::Rect.new 408, 216, 48, 272
        @scroll_knob = Moon::Sprite.new background_texture
        @scroll_knob.clip_rect = Moon::Rect.new 480, 224, 32, 32

        @tile_id = 0
        @row_index = 0
      end

      def position_to_tile_id(pos)
        (pos.x + pos.y * @visible_cols).to_i
      end

      def initialize_events
        super
        @cursor.on :moved do |e|
          @tile_id = position_to_tile_id e.position
        end
      end

      def w
        @w ||= @tileset ? @tileset.cell_w * @visible_cols : 0
      end

      def h
        @h ||= 16 + (@tileset ? @tileset.cell_h * @visible_rows : 0)
      end

      def tileset=(tileset)
        @tileset = tileset
        resize(nil, nil)
      end

      def tile_id=(n)
        old = @tile_id
        @tile_id = n.to_i
        if @tile_id != old
          @cursor.moveto((@tile_id.to_i % @visible_cols).floor,
                         (@tile_id.to_i / @visible_cols).floor)
        end
      end

      #
      def select_tile(*args)
        sx, sy = *Moon::Vector2.extract(args.singularize)
        pos = screen_to_relative(sx, sy).reduce(@tilesize)
        if relative_contains_pos?(pos)
          ps = (pos / @tilesize).floor
          self.tile_id = ps.x + (ps.y + @row_index) * @visible_cols
        end
      end

      def render_content(x, y, z, options)
        @background_s.render x - 8, y + 8, z

        if @tileset
          vis = @visible_rows * @visible_cols
          vis.times do |i|
            tx = (i % @visible_cols) * @tileset.cell_w
            ty = (i / @visible_cols).floor * @tileset.cell_h
            @tileset.render x + tx, y + ty + 16, z, @row_index + i
          end

          bx, by = x + @background_s.w + 8, y + 8
          @scroll_bar.render bx, by, 0
          inc = @tile_id.to_f / @tileset.cell_count
          knob_y = by + 8 + inc * @visible_rows * @tilesize.y
          @scroll_knob.render bx + 8, knob_y, 0
        end

        cp = @cursor.position * @tilesize
        if relative_contains_pos?(cp)
          @text.string = "Tile #{@tile_id}"
          @text.render x, y - 16, z
          @block_ss.render x + cp.x, y + cp.y + 16, z, 1
        end

        super
      end
    end
  end
end
