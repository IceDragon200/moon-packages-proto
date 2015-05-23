require 'render_primitives/render_context'

# Generic Renderer object for display a L shaped border
class BorderRenderer < Moon::RenderContext
  attr_accessor :border_rect
  attr_accessor :animate

  def init
    super
    @texture = TextureCache.ui('chunk_outline_3x3.png')
    @chunk_borders = Moon::Spritesheet.new(@texture, 32, 32)
    @border_rect = Moon::Rect.new(0, 0, 0, 0)

    @animate = false
    @amount = 8
    @direction = 1
    @offset = 0
    @speed = 1
  end

  def update_content(delta)
    if @animate
      @offset += @amount * delta * @direction * @speed
      if (@direction > 0 && @offset > @amount) ||
        (@direction < 0 && @offset < 0)
        @direction = -@direction
      end
    end
  end

  def render_content(x, y, z, options)
    unless @border_rect.empty?
      w = @border_rect.w - 32
      h = @border_rect.h - 32
      a = @animate ? @offset : 0
      @chunk_borders.render(x - a,     y - a,     z, 0)
      @chunk_borders.render(x + w + a, y - a,     z, 2)
      @chunk_borders.render(x - a,     y + h + a, z, 6)
      @chunk_borders.render(x + w + a, y + h + a, z, 8)
    end
  end
end
