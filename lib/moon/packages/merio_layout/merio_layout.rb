module Merio
  # Generic Rectangle class, defaults to floating point numbers
  class FloatRect
    # @return [Float]
    attr_accessor :x
    # @return [Float]
    attr_accessor :y
    # @return [Float]
    attr_accessor :w
    # @return [Float]
    attr_accessor :h

    # @param [Float] x
    # @param [Float] y
    # @param [Float] w
    # @param [Float] h
    def initialize(x = 0.0, y = 0.0, w = 0.0, h = 0.0)
      set x, y, w, h
    end

    # @param [Float] x
    # @param [Float] y
    # @param [Float] w
    # @param [Float] h
    def set(x, y, w, h)
      @x, @y, @w, @h = x.to_f, y.to_f, w.to_f, h.to_f
    end

    # Normalizes the w and h; x and y remain unchanged
    #
    # @return [FloatRect]
    def clamped
      FloatRect.new(x, y, [[0.0, w].max, 1.0].min, [[0.0, h].max, 1.0].min)
    end

    # Rounds all the coords to the nearest n
    # @return [FloatRect]
    def round(n = 0)
      FloatRect.new(x.round(n), y.round(n), w.round(n), h.round(n))
    end

    # @return [Array<Float>]
    def to_a
      return @x, @y, @w, @h
    end
  end

  # Sides represent margins, paddings etc.
  class Sides
    # @return [Float]
    attr_accessor :l
    # @return [Float]
    attr_accessor :t
    # @return [Float]
    attr_accessor :r
    # @return [Float]
    attr_accessor :b

    # @param [Float] l
    # @param [Float] t
    # @param [Float] r
    # @param [Float] b
    def initialize(l = 0, t = 0, r = 0, b = 0)
      set l, t, r, b
    end

    # @param [Float] l
    # @param [Float] t
    # @param [Float] r
    # @param [Float] b
    def set(l, t, r, b)
      @l, @t, @r, @b = l, t, r, b
    end

    # @return [Array<Float>]
    def to_a
      return @l, @t, @r, @b
    end
  end

  class Margins < Sides
  end

  class Paddings < Sides
  end

  # A layout is equivalent to a OUI item, layouts can contain other children
  # layouts.
  # All layouts have normalized sizes, paddings and margins.
  # Their size is relative to their caller specified coords.
  # As of such, a half-width layout at the root may represent half the screen;
  # while adopted, it may be half the size of the parent layout.
  class Layout
    # Represents both the position and size of the Layout
    # @return [FloatRect]
    attr_accessor :sizes
    # @return [Paddings]
    attr_accessor :paddings
    # @return [Margins]
    attr_accessor :margins
    # The layout's children
    # @return [Array<Layout>]
    attr_accessor :children
    # Consider this meta-data for your layout
    # @return [Object]
    attr_accessor :handle

    def initialize
      clear
    end

    # Reset the layout to its pristine condition
    #
    # @return [self]
    def clear
      @sizes = FloatRect.new 0, 0, 1, 1
      @paddings = Paddings.new
      @margins = Margins.new
      @children = []
      @handle = nil
      self
    end

    # Add a child to the layout's children
    #
    # @param [Layout] child
    # @return [Layout]  the same object you passed in
    private def add_item(itm)
      @children << itm
      itm
    end

    # Retrieve an item at index.
    #
    # @param [Integer] index
    # @return [Layout]
    def item(index)
      c = @children[index]
      yield c if block_given?
      return c
    end

    # Remove an item at index and return it.
    #
    # @param [Integer] index
    # @return [Layout]
    def drop_item(index)
      @children.delete_at(index)
    end

    # Add a new item
    #
    # @param [Float] x
    # @param [Float] y
    # @param [Float] w
    # @param [Float] h
    # @return [Layout]
    def new_item(x = 0, y = 0, w = 1, h = 1)
      l = Layout.new
      l.sizes.set x, y, w, h
      add_item l
    end

    # Divides the layout evenly horizontally.
    #
    # @param [Integer] divs
    # @yieldparam [Layout] layout
    # @yieldparam [Integer] index
    def horz(divs)
      fail if divs <= 0
      segsize = 1.0 / divs
      divs.times do |i|
        l = new_item i * segsize, 0, segsize, 1
        yield l, i if block_given?
      end
    end

    # Divides the layout evenly vertically.
    #
    # @param [Integer] divs
    # @yieldparam [Layout] layout
    # @yieldparam [Integer] index
    def vert(divs)
      fail if divs <= 0
      segsize = 1.0 / divs
      divs.times do |i|
        l = new_item 0, i * segsize, 1, segsize
        yield l, i if block_given?
      end
    end

    # Divides the layout into a grid.
    #
    # @param [Integer] cols
    # @param [Integer] rows
    # @yieldparam [Layout] layout_row
    # @yieldparam [Layout] layout_cell
    # @yieldparam [Integer] row_index
    # @yieldparam [Integer] cell_index
    def grid(cols, rows)
      vert rows do |r, i|
        r.horz cols do |c, j|
          yield r, c, i, j if block_given?
        end
      end
    end

    private def expand_sides(sides, ws, hs)
      return sides.l * ws, sides.t * hs, sides.r * ws, sides.b * hs
    end

    private def apply_inner_sides(sides, rect, ws, hs)
      l, t, r, b = *expand_sides(sides, ws, hs)
      FloatRect.new(rect.x + l, rect.y + t, rect.w - r - l, rect.h - b - t)
    end

    private def apply_outer_sides(sides, rect, ws, hs)
      l, t, r, b = *expand_sides(sides, ws, hs)
      FloatRect.new(rect.x - l, rect.y - t, rect.w + r + l, rect.h + b + t)
    end

    private def apply_margins(rect, ws, hs)
      apply_inner_sides @margins, rect, ws, hs
    end

    private def apply_parent_paddings(rect, ws, hs)
      apply_outer_sides @paddings, rect, ws, hs
    end

    private def apply_content_paddings(rect, ws, hs)
      apply_inner_sides @paddings, rect, ws, hs
    end

    # Renders the layout as a FloatRect.
    #
    # @param [Numeric] sx  x position
    # @param [Numeric] sy  y position
    # @param [Numeric] ws  width
    # @param [Numeric] hs  height
    # @yieldparam [FloatRect] calculated_rect
    # @yieldparam [Layout] layout
    def render(sx, sy, ws, hs, &block)
      x, y, w, h = ws * @sizes.x, hs * @sizes.y, ws * @sizes.w, hs * @sizes.h
      x += sx
      y += sy
      rect = FloatRect.new(x, y, w, h)
      mrect = apply_parent_paddings(apply_margins(rect, ws, hs), ws, hs)
      yield mrect, self
      mrect
    end

    # Renders the layout and all its children as FloatRects, each rect is
    # yielded along with its layout.
    #
    # @param [Numeric] sx  x position
    # @param [Numeric] sy  y position
    # @param [Numeric] ws  width
    # @param [Numeric] hs  height
    # @yieldparam [FloatRect] calculated_rect
    # @yieldparam [Layout] layout
    def render_all(sx, sy, ws, hs, &block)
      render sx, sy, ws, hs do |r, l|
        yield r, l
        prect = apply_content_paddings(r, ws, hs)
        @children.each do |itm|
          itm.render_all(prect.x, prect.y, prect.w, prect.h, &block)
        end
      end
    end
  end
end
