module UI
  class ContextBase
    attr_reader :vg

    def initialize(vg)
      @vg = vg
    end

    def select_corners(r, flags)
      a = [r, r, r, r]
      a[0] = 0 if flags.masked? BND::CORNER_TOP_LEFT
      a[1] = 0 if flags.masked? BND::CORNER_TOP_RIGHT
      a[2] = 0 if flags.masked? BND::CORNER_DOWN_RIGHT
      a[3] = 0 if flags.masked? BND::CORNER_DOWN_LEFT
      a
    end

    def offset_color(color, delta)
      return color if delta == 0.0
      offset = delta / 255.0
      NVG.rgbaf([[color.r + offset, 0].max, 1].min,
                [[color.g + offset, 0].max, 1].min,
                [[color.b + offset, 0].max, 1].min,
                color.a)
    end

    def inner_box(x, y, w, h, cr0, cr1, cr2, cr3, shade_top, shade_down)
      @vg.path do |v|
        v.rounded_box(x + 1, y + 1, w - 2, h - 3,
                      [0, cr0 - 1].max, [0, cr1 - 1].max,
                      [0, cr2 - 1].max, [0, cr3 - 1].max)

        v.fill_paint(if (h - 2) > w
          @vg.linear_gradient(x, y, x + w, y, shade_top, shade_down)
        else
          @vg.linear_gradient(x, y, x, y + h, shade_top, shade_down)
        end)
        v.fill
      end
      self
    end

    def inner_circ(cx, cy, r, cr0, cr1, cr2, cr3, shade_top, shade_down)
      @vg.path do |v|
        v.circle cx, cy, r
        x, y = cx - r, cy - r
        w = h = r * 2
        v.fill_paint @vg.linear_gradient(x, y, x, y + h, shade_top, shade_down)
        v.fill
      end
      self
    end

    def outline_box(x, y, w, h, cr0, cr1, cr2, cr3, color)
      @vg.path do |v|
        v.rounded_box x + 0.5, y + 0.5, w - 1, h - 2, cr0, cr1, cr2, cr3
        v.stroke_color color
        v.stroke_width 1
        v.stroke
      end
      self
    end

    def outline_circ(cx, cy, r, cr0, cr1, cr2, cr3, color)
      @vg.path do |v|
        v.circle cx + 0.5, cy + 0.5, r + 1
        v.stroke_color color
        v.stroke_width 1
        v.stroke
      end
      self
    end

    def inline_box(x, y, w, h, cr0, cr1, cr2, cr3, color)
      @vg.path do |v|
        r = 1.5
        r2 = r * 2
        v.rounded_inline_box x + r, y + r, w - r2, h - r2 - (@cr / 2.0), cr0, cr1, cr2, cr3
        v.stroke_color color
        v.stroke_width 1
        v.stroke
      end
      self
    end

    def inline_circ(cx, cy, r, cr0, cr1, cr2, cr3, color)
      @vg.path do |v|
        v.arc cx, cy, r - 0.5, Math::PI, Math::PI * 1.7, NVG::CW
        v.stroke_color color
        v.stroke_width 1
        v.stroke
      end
      self
    end

    def expand_rect(hz, vt, x, y, w, h)
      return x - hz, y - vt, w + hz * 2, h + vt * 2
    end

    def expand_circ(o, x, y, r)
      return x, y, r + o * 2
    end

    def offset_circ(x, y, r)
      return x + r, y + r
    end
  end
end

module Nanovg
  class Context
    def arc_or_move_to(bool, x, y, *args)
      if bool
        arc_to x, y, *args
      else
        move_to x, y
      end
    end

    def rounded_box_open_path(x, y, w, h, cr0, cr1, cr2, cr3)
      w = [0, w].max
      h = [0, h].max
      d = [w, h].min
      hd = d / 2.0
      move_to x, y + h * 0.5
      arc_or_move_to cr0 >= 0,  x,     y,     x + w, y,     [cr0, hd].min
      arc_or_move_to cr1 >= 0,  x + w, y,     x + w, y + h, [cr1, hd].min
      arc_or_move_to cr2 >= 0,  x + w, y + h, x,     y + h, [cr2, hd].min
      arc_or_move_to cr3 >= 0,  x,     y + h, x,     y,     [cr3, hd].min
      self
    end

    def rounded_box(x, y, w, h, cr0, cr1, cr2, cr3)
      rounded_box_open_path x, y, w, h, cr0, cr1, cr2, cr3
      close_path
      self
    end

    def rounded_inline_box(x, y, w, h, cr0, cr1, cr2, cr3)
      w = [0, w].max
      h = [0, h].max
      d = [w, h].min
      hd = d / 2.0
      move_to x, y + h - cr3
      arc_to x, y, x + w, y, [cr0, hd].min
      arc_to x + w, y, x + w, y + h, [cr1, hd].min
      #move_to x + cr3, y + h
      #arc_to x, y + h * 0.5, x, y, [cr3, hd].min
    end
  end
end
