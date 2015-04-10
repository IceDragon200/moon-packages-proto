require 'nui/render/base'

module UI
  # This is a rewrite of the mruby-blendish class/module in pure mruby using
  # mruby-nanovg
  module Blendish
    class Context < ContextBase
      attr_accessor :theme
      attr_accessor :icon_image
      attr_accessor :font

      def initialize(vg)
        super
        @theme = BNDThemes.default
        @icon_image = -1
        @font = -1


        @label_font_size = 13

        @pad_left = 8
        @pad_right = 8

        @label_seperator = ': '

        @transparent_alpha = 0.643

        @bevel_shade = 30
        @inset_bevel_shade = 30
        @hover_shade = 15
        @splitter_shade = 100

        @icon_sheet_width = 602
        @icon_sheet_height = 640
        @icon_sheet_grid = 21
        @icon_sheet_offset_x = 5
        @icon_sheet_offset_y = 10
        @icon_sheet_res = 16

        @number_arrow_size = 4

        @color_text = NVG.rgbaf(0, 0, 0, 1)
        @color_text_selected = NVG.rgbaf(1, 1, 1, 1)

        @tool_radius = 4

        @option_radius = 4
        @option_width = 14
        @option_height = 15

        @text_radius = 4

        @number_radius = 10

        @menu_radius = 3
        @shadow_feather = 12
        @shadow_alpha = 0.5

        @scrollbar_radius = 7
        @scrollbar_active_shade = 15

        @max_glyphs = 1024

        @max_rows = 32

        @text_pad_down = 7

        @node_wire_outline_width = 4
        @node_wire_wire_width = 2
        @node_node_radius = 8
        @node_node_title_feather = 1
        @node_node_arrow_size = 9

        @disabled_alpha = BND::DISABLED_ALPHA
        @widget_height = BND::WIDGET_HEIGHT
        @tool_width = BND::TOOL_WIDTH
        @node_port_radius = BND::NODE_PORT_RADIUS
        @node_margin_top = BND::NODE_MARGIN_TOP
        @node_margin_down = BND::NODE_MARGIN_DOWN
        @node_margin_side = BND::NODE_MARGIN_SIDE
        @node_title_height = BND::NODE_TITLE_HEIGHT
        @node_arrow_area_width = BND::NODE_ARROW_AREA_WIDTH

        @splitter_area_size = BND::SPLITTER_AREA_SIZE

        @scrollbar_width = BND::SCROLLBAR_WIDTH
        @scrollbar_height = BND::SCROLLBAR_HEIGHT

        @vspacing = BND::VSPACING
        @vspacing_group = BND::VSPACING_GROUP
        @hspacing = BND::HSPACING
      end

      def label_width(iconid = 0, label = nil)
        w = @pad_left + @pad_right
        w += @icon_sheet_res if iconid >= 0
        if label && (@font >= 0)
          @vg.font_face_id @font
          @vg.font_size @label_font_size
          w += @vg.text_bounds 1, 1, label
        end
        return w
      end

      def label_height(iconid, label, width)
        h = @widget_height
        width -= @text_radius * 2
        width -= @icon_sheet_res if iconid >= 0
        if label && (@font >= 0)
          @vg.font_face_id @font
          @vg.font_size @label_font_size
          bounds = NVG::Transform.new
          @vg.text_box_bounds 1, 1, width, label, bounds
          bh = bounds.d - bounds.b + @text_pad_down
          h = bh if bh > h
        end
        h
      end

      def transparent(color)
        color.dup.tap { |c| c.a *= @transparent_alpha }
      end

      def inner_colors(wtheme, state, flip = false)
        case state
        when BND::DEFAULT
          return offset_color(wtheme.inner_color, wtheme.shade_top),
                 offset_color(wtheme.inner_color, wtheme.shade_down)
        when BND::HOVER
          c = offset_color(wtheme.inner_color, @hover_shade)
          return offset_color(c, wtheme.shade_top),
                 offset_color(c, wtheme.shade_down)
        when BND::ACTIVE
          return offset_color(wtheme.inner_selected_color, flip ? wtheme.shade_down : wtheme.shade_top),
                 offset_color(wtheme.inner_selected_color, flip ? wtheme.shade_top : wtheme.shade_down)
        else
          fail "Invalid state #{state}"
        end
      end

      def text_color(wtheme, state)
        state == BND::ACTIVE ? wtheme.text_selected_color : wtheme.text_color
      end

      def scroll_handle_rect(x, y, w, h, offset, size)
        size = [[size, 0].max, 1].min
        offset = [[offset, 0].max, 1].min

        if h > w
          hs = [size * h, w + 1].max
          return x, y + (h - hs) * offset, w, hs
        else
          ws = [size * w, h - 1].max
          return x + (w - ws) * offset, y, ws, h
        end
      end

      def icon_label_text_position(x, y, w, h, iconid, fontsize, label, px, py)
        pleft = @text_radius

        return -1 unless label
        return -1 if font < 0
        pleft += @icon_sheet_res if iconid >= 0

        x += pleft
        y += @widget_height - @text_pad_down

        @vg.font_face_id @font
        @vg.font_size fontsize
        @vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_BASELINE

        w -= @text_radius + pleft

      end

      def icon(x, y, iconid)
        return if @icon_image < 0

        ix = iconid & 0xFF
        iy = (iconid >> 8) & 0xFF
        u = @icon_sheet_offset_x + ix * @icon_sheet_grid
        v = @icon_sheet_offset_y + iy * @icon_sheet_grid

        @vg.path do |v|
          v.rect x, y, @icon_sheet_res, @icon_sheet_res
          v.fill_paint v.image_pattern(x - u, y - v, @icon_sheet_width, @icon_sheet_height, 0, @icon_image, 1)
          v.fill
        end
        self
      end

      def icon_label_value(x, y, w, h, iconid, color, align, fontsize, label, value)
        pleft = @pad_left
        if label
          if iconid >= 0
            icon x + 4, y + 2, iconid
            pleft += @icon_sheet_res
          end

          return if @font < 0

          @vg.font_face_id font
          @vg.font_size fontsize

          @vg.path do |v|
            v.fill_color color
            if value
              label_width = v.text_bounds 1, 1, label
              sep_width = v.text_bounds 1, 1, @label_seperator

              v.text_align NVG::ALIGN_LEFT | NVG::ALIGN_BASELINE
              x += pleft

              if align == BND::CENTER
                width = label_width + sep_width + v.text_bounds(1, 1, value)
                x += ((w - @pad_right - pleft) - width) * 0.5
              end

              y += @widget_height - @text_pad_down
              v.text x, y, label
              x += label_width
              v.text x, y, @label_seperator
              x += sep_width
              v.text x, y, value
            else
              a = align == BND::LEFT ? (NVG::ALIGN_LEFT | NVG::ALIGN_BASELINE) :
                                       (NVG::ALIGN_CENTER | NVG::ALIGN_BASELINE)
              v.text_align a
              v.text_box x + pleft, y + @widget_height - @text_pad_down, w - @pad_right - pleft, label
            end
          end
        elsif iconid >= 0
          icon x + 2, y + 2, iconid
        end
        self
      end

      def label(x, y, w, h, iconid = -1, label = nil)
        icon_label_value x, y, w, h, iconid, theme.regular_theme.text_color, @left
        self
      end

      def bevel(x, y, w, h)
        @vg.stroke_width 1

        x += 0.5
        y += 0.5
        w -= 1
        h -= 1

        @vg.path do |v|
          v.move_to x, y + h
          v.line_to x + w, y + h
          v.line_to x + w, y
          v.stroke_color transparent(offset_color(theme.background_color, -@bevel_shade))
          v.stroke
        end

        @vg.path do |v|
          v.move_to x, y + h
          v.line_to x, y
          v.line_to x + w, y
          v.stroke_color transparent(offset_color(theme.background_color, @bevel_shade))
          v.stroke
        end
        self
      end

      def bevel_inset(x, y, w, h, cr2, cr3)
        y -= 0.5
        d = [w, h].min
        hd = d / 2
        cr2 = [cr2, hd].min
        cr3 = [cr3, hd].min

        bevel_color = offset_color theme.background_color, @inset_bevel_shade

        @vg.path do |v|
          v.move_to x + w, y + h - cr2
          v.arc_to x + w, y + h, x, y + h, cr2
          v.arc_to x, y + h, x, y, cr3

          v.stroke_width 1
          v.stroke_paint v.linear_gradient(x, y + h - [cr2, cr3].max - 1,
                                           x, y + h - 1,
                                           NVG.rgbaf(bevel_color.r,
                                                     bevel_color.g,
                                                     bevel_color.b,
                                                     0),
                                           bevel_color)
          v.stroke
        end
        self
      end

      def background(x, y, w, h)
        @vg.path do |v|
          v.rect x, y, w, h
          v.fill_color theme.background_color
          v.fill
        end
        self
      end

      def buttonbase(t, r, x, y, w, h, flags, state, iconid, label)
        cr = select_corners(r, flags)
        shade_top, shade_down = inner_colors t, state, true

        bevel_inset x, y, w, h, cr[2], cr[3]
        inner_box x, y, w, h, cr[0], cr[1], cr[2], cr[3], shade_top, shade_down
        outline_box x, y, w, h, cr[0], cr[1], cr[2], cr[3], transparent(t.outline_color)
        icon_label_value x, y, w, h, iconid, text_color(t, state), BND::CENTER, @label_font_size, label, nil

        self
      end

      def tool_button(x, y, w, h, flags, state, iconid = -1, label = nil)
        buttonbase theme.tool_theme, @tool_radius, x, y, w, h, flags, state, iconid, label
      end

      def radio_button(x, y, w, h, flags, state, iconid = -1, label = nil)
        buttonbase theme.radio_theme, @option_radius, x, y, w, h, flags, state, iconid, label
      end

      def text_field_text_position(x, y, w, h, iconid, text, px, py)
        icon_label_text_position x, y, w, h, iconid, @label_font_size, text, px, py
      end

      def text_field(x, y, w, h, flags, state, iconid = -1, text = nil, cbegin = -1, cend = -1)
        t = theme.text_field_theme
        cr = select_corners @text_radius, flags
        shade_top, shade_down = inner_colors t, state, false

        bevel_inset x, y, w, h, cr[2], cr[3]
        inner_box x, y, w, h, cr[0], cr[1], cr[2], cr[3], shade_top, shade_down
        outline_box x, y, w, h, cr[0], cr[1], cr[2], cr[3], transparent(t.outline_color)
        cend = -1 if state != BND::ACTIVE
        icon_label_caret x, y, w, h, iconid, text_color(t, state), @label_font_size, text, t.item_color, cbegin, cend
        self
      end

      def option_button(x, y, w, h, state, label = nil)
        ox = x
        oy = y + h - @option_height - 3
        t = theme.option_theme
        shade_top, shade_down = inner_colors t, state, true

        bevel_inset ox, oy, @option_width, @option_height, @option_radius, @option_radius
        inner_box ox, oy, @option_width, @option_height,
                  @option_radius, @option_radius, @option_radius, @option_radius,
                  shade_top, shade_down
        outline_box ox, oy, @option_width, @option_height,
                    @option_radius, @option_radius, @option_radius, @option_radius,
                    transparent(t.outline_color)
        check ox, oy, transparent(t.item_color) if state == BND::ACTIVE
        icon_label_value x + 12, y, w - 12, h, -1, text_color(t, state),
                         BND::LEFT, @label_font_size, label, nil
        self
      end

      def choice_button(x, y, w, h, flags, state, iconid = -1, label = nil)
        self
      end

      def color_button(x, y, w, h, flags, color)
        self
      end

      def number_field(x, y, w, h, flags, state, label, value)
        self
      end

      def slider(x, y, w, h, flags, state, progress, label, value)
        self
      end

      def scroll_bar(x, y, w, h, state, offset, size)
        self
      end

      def menu_background(x, y, w, h, flags)
        self
      end

      def menu_label(x, y, w, h, iconid, label)
        self
      end

      def menu_item(x, y, w, h, state, iconid, label)
        self
      end

      def tooltip_background(x, y, w, h)
        self
      end

      def node_port(x, y, state, color)
        self
      end

      def node_wire(x0, y0, x1, y1, state0, state1)
        self
      end

      def colored_node_wire(x0, y0, x1, y1, color0, color1)
        self
      end

      def node_background(x, y, w, h, state, iconid, label, title_color)
        self
      end

      def splitter_widgets(x, y, w, h)
        self
      end

      def join_area_overlay(x, y, w, h, vertical, mirror)
        self
      end

      def drop_shadow(x, y, w, h, r, feather, alpha)
        self
      end

      def node_icon_label(x, y, w, h, iconid, color, shadow_color, align, fontsize, label)
        self
      end

      def icon_label_caret(x, y, w, h, iconid, color, fontsize, label, caretcolor, cbegin, cend)
        self
      end

      def check(ox, oy, color)
        @vg.path do |v|
          v.stroke_width 2
          v.stroke_color color
          v.line_cap NVG::BUTT
          v.line_join NVG::MITER
          v.move_to ox + 4, oy + 5
          v.line_to ox + 7, oy + 8
          v.line_to ox + 14, oy + 1
          v.stroke
        end
        self
      end

      def arrow(x, y, s, color)
        self
      end

      def up_down_arrow(x, y, s, color)
        self
      end

      def node_arrow_down(x, y, s, color)
        self
      end

      def node_wire_color(ntheme, state)
        return c
      end
    end
  end
end
