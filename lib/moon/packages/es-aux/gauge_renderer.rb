class GaugeRenderer < Moon::RenderContext
  attr_reader :rate

  def init
    super
    @rate = 1.0
  end

  def set_texture(texture, cw, ch)
    @gauge_texture = texture
    @base_sprite = Moon::Sprite.new(@gauge_texture)
    @base_sprite.clip_rect = Moon::Rect.new(0, 0, cw, ch)
    @bar_sprite = Moon::Sprite.new(@gauge_texture)
    @bar_sprite.clip_rect = Moon::Rect.new(0, ch, cw, ch)

    @base_sprite.ox = @base_sprite.w / 2
    @base_sprite.oy = @base_sprite.h
    @bar_sprite.ox = @bar_sprite.w / 2
    @bar_sprite.oy = @bar_sprite.h

    self.w = @base_sprite.w
    self.h = @base_sprite.h
  end

  def render_content(x, y, z, options)
    if @base_sprite
      @base_sprite.render(x-@base_sprite.ox, y-@base_sprite.oy, z)
    end
    if @bar_sprite
      @bar_sprite.render(x-@bar_sprite.ox, y-@bar_sprite.oy, z)
    end
    super
  end

  def rate=(rate)
    @rate = [[rate, 1.0].min, 0.0].max
    if @bar_sprite
      rect = @bar_sprite.clip_rect.dup
      rect.w = @gauge_texture.w * @rate
      @bar_sprite.clip_rect = rect
    end
  end
end
