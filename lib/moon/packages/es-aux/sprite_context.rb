class SpriteContext < Moon::RenderContext
  attr_accessor :sprite

  # @return [Moon::Texture]
  def texture
    @sprite.texture
  end

  # @param [Moon::Texture] texture
  def texture=(texture)
    @sprite.texture = texture
  end

  # @return [Moon::Rect]
  def clip_rect
    @sprite.clip_rect
  end

  # @param [Moon::Rect] clip_rect
  def clip_rect=(clip_rect)
    @sprite.clip_rect = clip_rect
  end

  # @return [Integer]
  def w
    (@sprite && @sprite.w) || 0
  end

  # @return [Integer]
  def h
    (@sprite && @sprite.h) || 0
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] z
  # @param [Hash] options
  def render_content(x, y, z, options)
    if @sprite
      o = @sprite.opacity
      if n = options[:opacity]
        @sprite.opacity = o * n
      end
      @sprite.render(x, y, z)
      @sprite.opacity = o
    end
  end
end
