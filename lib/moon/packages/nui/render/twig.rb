module UI
  # This is a implementation of the Bitwig UI
  module Twig
    class << self
      attr_accessor :colors
    end

    @colors = [
      NVG.mono(122), NVG.rgb(217, 46, 38), NVG.rgb(255, 87, 6),
      NVG.rgb(217, 157, 16), NVG.rgb(115, 152, 20), NVG.rgb(0, 157, 71),

      NVG.mono(201), NVG.rgb(236, 97, 87), NVG.rgb(255, 131, 62),
      NVG.rgb(228, 183, 78), NVG.rgb(160, 192, 76), NVG.rgb(62, 187, 98),

      NVG.rgb(0, 166, 148), NVG.rgb(0, 153, 217), NVG.rgb(87, 97, 198),
      NVG.rgb(149, 73, 203), NVG.rgb(217, 56, 113), NVG.rgb(163, 121, 67),

      NVG.rgb(67, 210, 185), NVG.rgb(68, 200, 255), NVG.rgb(132, 138, 224),
      NVG.rgb(188, 116, 240), NVG.rgb(225, 102, 145), NVG.rgb(198, 159, 112),
    ]

    class StateTheme
      attr_accessor :inner_color
      attr_accessor :outline_color
      attr_accessor :inline_color
      attr_accessor :text_color
      attr_accessor :shade_top
      attr_accessor :shade_down

      def initialize
        @inner_color   = NVG.mono(0)
        @outline_color = NVG.mono(0)
        @inline_color  = NVG.mono(0)
        @text_color    = NVG.mono(0)
        @shade_top     = 0
        @shade_down    = 0

        yield self if block_given?
      end
    end

    class WidgetTheme
      attr_accessor :default
      attr_accessor :hover
      attr_accessor :active

      def initialize
        @default = StateTheme.new
        @hover = StateTheme.new
        @active = StateTheme.new

        yield self if block_given?
      end
    end

    class Theme
      attr_accessor :background_color

      attr_accessor :active
      attr_accessor :control
      attr_accessor :default
      attr_accessor :hover
      attr_accessor :menu
      attr_accessor :panel
      attr_accessor :rack
      attr_accessor :tab

      def initialize
        @background_color = NVG.mono(58)

        @default = StateTheme.new do |t|
          t.inner_color = NVG.mono(73)
          t.outline_color = NVG.mono(22)
          t.inline_color = NVG.mono(86)
          t.text_color = NVG.mono(178)
          t.shade_down = -7
        end

        @control = WidgetTheme.new do |t|
          t.default = StateTheme.new do |s|
            s.inner_color = NVG.mono(73)
            s.outline_color = NVG.mono(22)
            s.inline_color = NVG.mono(86)
            s.text_color = NVG.mono(178)
            s.shade_down = -7
          end
          t.hover = StateTheme.new do |s|
            s.inner_color = NVG.mono(73)
            s.outline_color = NVG.mono(22)
            s.inline_color = NVG.mono(86)
            s.text_color = NVG.mono(178)
            s.shade_down = -7
          end
          t.active = StateTheme.new do |s|
            s.inner_color = Twig.colors[2].dup
            s.outline_color = NVG.mono(22)
            s.inline_color = NVG.mono(86)
            s.text_color = NVG.mono(178)
            s.shade_down = -7
          end
        end

        @menu = StateTheme.new do |t|
          t.inner_color = NVG.mono(27)
          t.outline_color = NVG.mono(16)
          t.inline_color = NVG.mono(24)
          t.text_color = NVG.mono(125)
        end

        @panel = StateTheme.new do |t|
          t.inner_color = NVG.mono(50)
          t.outline_color = NVG.mono(22)
          t.inline_color = NVG.mono(81)
          t.text_color = NVG.mono(120)
        end

        @rack = StateTheme.new do |t|
          t.inner_color = NVG.mono(58)
          t.outline_color = NVG.mono(22)
          t.inline_color = NVG.mono(81)
          t.text_color = NVG.mono(185)
        end

        @hover = StateTheme.new do |t|
          t.inner_color = NVG.mono(50)
          t.outline_color = NVG.mono(22)
          t.inline_color = NVG.mono(46)
          t.text_color = NVG.mono(178)
          t.shade_down = 0
        end

        @active = StateTheme.new do |t|
          t.inner_color = NVG.rgb(212, 87, 21)
          t.outline_color = NVG.mono(22)
          t.inline_color = NVG.rgb(217, 106, 47)
          t.text_color = NVG.mono(18)
          t.shade_down = -6
        end

        @tab = WidgetTheme.new do |t|
          t.default = StateTheme.new do |s|
            s.inner_color = NVG.mono 58
            s.outline_color = NVG.mono 22 # 0
            s.inline_color = NVG.mono 71
            s.text_color = NVG.mono 163
          end
          t.hover = StateTheme.new do |s|
            s.inner_color = NVG.mono 58
            s.outline_color = NVG.mono 22 # 0
            s.inline_color = NVG.mono 71
            s.text_color = NVG.mono 163
          end
          t.active = StateTheme.new do |s|
            s.inner_color = NVG.mono 66
            s.outline_color = NVG.mono 22 # 0
            s.inline_color = NVG.mono 79
            s.text_color = NVG.mono 163
          end
        end
      end
    end

    class Context < ContextBase
      attr_accessor :theme
      attr_accessor :font

      def initialize(vg)
        super
        @theme = Theme.new
        @font = -1
        @cr = 3
      end

      def label(x, y, w, h, label)
        @vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_BASELINE
        @vg.font_face_id @font
        @vg.font_size 16
        @vg.text x, y, label
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

      def menu_background(x, y, w, h, flags)
        cra = select_corners @cr, flags
        @vg.path do |v|
          v.stroke_width 1
          v.rounded_box x, y, w, h, cra[0], cra[1], cra[2], cra[3]
          v.fill_color theme.menu.inner_color
          v.stroke_color theme.menu.outline_color
          v.fill
          v.stroke
        end
        self
      end

      def state_theme(state, theme)
        case state
        when BND::DEFAULT then theme.default
        when BND::HOVER   then theme.hover
        when BND::ACTIVE  then theme.active
        else
          fail "Invalid state #{state}"
        end
      end

      def check(ox, oy, color)
        ox += 3
        oy += 7
        @vg.path do |v|
          v.stroke_width 2
          v.stroke_color color
          v.line_cap NVG::BUTT
          v.line_join NVG::MITER
          v.move_to ox, oy
          v.line_to ox + 3, oy + 3
          v.line_to ox + 8, oy - 4
          v.stroke
        end
        self
      end

      def dot(ox, oy, color)
        @vg.path do |v|
          v.circle ox + 0.5, oy + 0.5, 2
          v.fill_color color
          v.fill
        end
      end

      def roundbase(theme, x, y, w, h, flags, state, cr)
        cra = select_corners cr, flags
        t = state_theme state, theme
        shade_top = offset_color t.inner_color, t.shade_top
        shade_down = offset_color t.inner_color, t.shade_down

        x, y, w, h = expand_rect 1, 1, x, y, w, h

        inner_box x, y, w, h, cra[0], cra[1], cra[2], cra[3], shade_top, shade_down
        outline_box x, y, w, h, cra[0], cra[1], cra[2], cra[3], t.outline_color
        inline_box x, y, w, h, cra[0], cra[1], cra[2], cra[3], t.inline_color

        @vg.fill_color t.text_color
      end

      def filter_buttonbase(x, y, w, h, flags, state)
        roundbase @theme, x, y, w, h, flags, state, 8
      end

      def sqr_buttonbase(x, y, w, h, flags, state)
        roundbase @theme, x, y, w, h, flags, state, @cr
      end

      def tab(x, y, w, h, flags, state)
        roundbase @theme.tab, x, y, w, h, flags, state, 5
      end

      def colored_box(x, y, w, h, flags, color)
        cra = select_corners 1, flags
        outline_color = offset_color color, 40
        inner_box x, y, w, h, cra[0], cra[1], cra[2], cra[3], color, color
        outline_box x, y, w, h, cra[0], cra[1], cra[2], cra[3], outline_color
      end

      def circ_buttonbase(cx, cy, r, flags, state)
        cra = select_corners @cr, flags
        t = state_theme state, @theme
        shade_top = offset_color t.inner_color, t.shade_top
        shade_down = offset_color t.inner_color, t.shade_down

        x, y, r = expand_circ 1, cx, cy, r

        inner_circ x, y, r, cra[0], cra[1], cra[2], cra[3], shade_top, shade_down
        outline_circ x, y, r, cra[0], cra[1], cra[2], cra[3], t.outline_color
        inline_circ x, y, r, cra[0], cra[1], cra[2], cra[3], t.inline_color

        @vg.fill_color t.text_color
      end

      def filledbox(x, y, w, h, color)
        @vg.path do |v|
          v.rect x, y, w, h
          v.fill_color color
          v.fill
        end
      end

      def sidestrips(x, y, w, h, l, t, r, d, sidecolor)
        if l > 0
          filledbox x, y, l, h, sidecolor
        end

        if t > 0
          filledbox x, y, w, t, sidecolor
        end

        if r > 0
          filledbox x + w - r, y, r, h, sidecolor
        end

        if d > 0
          filledbox x, y + h - d, w, d, sidecolor
        end
      end

      def panelbase(t, x, y, w, h)
        cr = 0
        @vg.path do |v|
          if cr == 0
            v.rect x, y, w, h
          else
            v.rounded_box x, y, w, h, cr, cr, cr, cr
          end
          v.stroke_color t.outline_color
          v.stroke_width 2
          v.fill_color t.inner_color
          v.fill
          v.stroke
        end

        @vg.path do |v|
          v.rect x + 1, y + 1, w - 2, 1
          v.fill_color t.inline_color
          v.fill
        end

        # VU meters
        #2.times do |i|
        #  @vg.path do |v|
        #    v.rect x + w - 3 - 3 * (i + 1), y + 3, 2, h - 6
        #    v.fill_color theme.default.handle_color
        #    v.fill
        #  end
        #end
      end

      def panel(x, y, w, h, sidecolor = nil)
        panelbase theme.panel, x, y, w, h
        if sidecolor
          sidestrips x + 1, y + 1, w - 2, h - 2, 5, 0, 0, 0, sidecolor
        end
      end

      def rack(x, y, w, h, sidecolor = nil)
        panelbase theme.rack, x, y, w, h
        if sidecolor
          sidestrips x + 1, y + 1, w - 2, h - 2, 5, 0, 0, 0, sidecolor
        end
      end

      def control(cx, cy, r, rate)
        t = @theme.control
        gs = [r * 0.15, 2].max # guide size
        r -= gs
        kr = r - gs * 3 # knob radius
        mr = r * 0.075
        mrp = kr - r * 0.11
        sr = Math::PI * 0.75
        ed = Math::PI * 2.25
        df = sr + (ed - sr) * rate

        circ_buttonbase cx, cy, kr, BND::CORNER_NONE, BND::DEFAULT

        @vg.path do |v|
          v.circle cx + Math.cos(df) * mrp, cy + Math.sin(df) * mrp, mr
          v.fill_color NVG.mono(153)
          v.fill
        end

        @vg.path do |v|
          v.arc cx + 0.5, cy + 0.5, r, sr, ed, NVG::CW
          v.stroke_width gs
          v.stroke_color t.default.inner_color
          v.stroke
        end

        @vg.path do |v|
          v.arc cx + 0.5, cy + 0.5, r, sr, df, NVG::CW
          v.stroke_width gs * 0.66
          v.stroke_color t.active.inner_color
          v.stroke
        end
      end
    end
  end
end
