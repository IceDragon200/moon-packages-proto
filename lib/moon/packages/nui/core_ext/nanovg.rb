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

    # @param [Float] x
    # @param [Float] y
    # @param [Float] r
    # @param [Integer] sides
    def polygon(x, y, r, sides)
      return if sides == 0
      move_to x + r, y
      sides.times do |inx|
        a = Math::PI2 * inx / sides.to_f
        line_to x + (r * Math.cos(a)), y + (r * Math.sin(a))
      end
      close_path
      self
    end
  end

  # Really only one Nanovg::Context should exist at a time, unless you manage
  # to get a really nice multi-threaded mruby, then I guess you can try your
  # hand at multiple contexts.
  #
  # @return [Nanovg::Context]
  def self.instance
    @instance ||= Context.new(ANTIALIAS)
  end
end
