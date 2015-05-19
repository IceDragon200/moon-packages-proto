class EntityRenderer < Moon::RenderContext
  attr_accessor :index
  attr_accessor :tilesize
  attr_reader :entity

  def init
    super
    @index = 0
    @entity = nil
    @sprite = nil
    @tilesize = Moon::Vector3.new(32, 32, 32)
    @border_renderer = BorderRenderer.new
  end

  def entity=(entity)
    @entity = entity
    @sprite = nil
    if @entity
      filename = 'oryx_lofi_fantasy/3x/lofi_char_3x.png'
      texture = TextureCache.tileset filename
      @sprite = Moon::Sprite.new(texture)
      @sprite.clip_rect = Moon::Rect.new(0, 0, 24, 24)
      @sprite.ox = @sprite.w / 2
      @sprite.oy = @sprite.h / 2
      @hp_gauge = GaugeRenderer.new
      @hp_gauge.set_texture(TextureCache.gauge('gauge_48x6_hp.png'), 48, 6)
      @mp_gauge = GaugeRenderer.new
      @mp_gauge.set_texture(TextureCache.gauge('gauge_48x4_mp.png'), 48, 4)
    end
  end

  def update_content(delta)
    if @entity
      if health = @entity[:health]
        @hp_gauge.rate = health.rate
        @hp_gauge.show unless @hp_gauge.visible?
      else
        @hp_gauge.rate = 0
        @hp_gauge.hide if @hp_gauge.visible?
      end
      if mana = @entity[:mana]
        @mp_gauge.rate = mana.rate
        @mp_gauge.show unless @mp_gauge.visible?
      else
        @mp_gauge.rate = 0
        @mp_gauge.hide if @mp_gauge.visible?
      end
    end
  end

  def render_content(x, y, z, options)
    return unless @entity
    @entity.comp(:transform, :sprite) do |t, s|
      charpos = Moon::Vector3.new(x, y, z) + t.position * @tilesize

      sx = charpos.x - @sprite.ox
      sy = charpos.y - @sprite.oy
      sz = charpos.z
      @sprite.render(sx, sy, sz)
      @mp_gauge.render(charpos.x, sy, sz, options)
      @hp_gauge.render(charpos.x, sy - @mp_gauge.h, sz, options)

      bounds = Moon::Cuboid.new(sx, sy, sz, @sprite.w, @sprite.h, 1)
      s.bounds = bounds
      #@border_renderer.border_rect = bounds.to_rect_xy
      #@border_renderer.render(bounds.x, bounds.y, bounds.z)
    end
  end
end
