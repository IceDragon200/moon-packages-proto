require 'render_primitives/render_context'

# Generic Renderer object for display a L shaped border
class BorderRenderer < Moon::RenderContext
  attr_accessor :border_rect

  def init
    super
    @texture = TextureCache.ui('chunk_outline_3x3.png')
    @chunk_borders = Moon::Spritesheet.new(@texture, 32, 32)
    @border_rect = Moon::Rect.new(0, 0, 0, 0)
  end

  def render_content(x, y, z, options)
    unless @border_rect.empty?
      w = @border_rect.w - 32
      h = @border_rect.h - 32
      @chunk_borders.render(x,     y,     z, 0)
      @chunk_borders.render(x + w, y,     z, 2)
      @chunk_borders.render(x,     y + h, z, 6)
      @chunk_borders.render(x + w, y + h, z, 8)
    end
  end
end
