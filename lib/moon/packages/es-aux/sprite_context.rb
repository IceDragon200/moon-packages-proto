class SpriteContext < Moon::RenderContext
  attr_accessor :sprite

  def w
    (@sprite && @sprite.w) || 0
  end

  def h
    (@sprite && @sprite.h) || 0
  end

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
