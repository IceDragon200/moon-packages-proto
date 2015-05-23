class EntityRenderer < Moon::RenderContext
  attr_accessor :index
  attr_accessor :tilesize
  attr_reader :entity

  def init
    super
    @index = 0
    @entity = nil
    @sprite = nil
    @blok = Moon::Spritesheet.new TextureCache.block('a032x032.png'), 32, 32
    @tilesize = Moon::Vector3.new(32, 32, 32)
    @border_renderer = BorderRenderer.new
  end

  def entity=(entity)
    @entity = entity
    @sprite = nil
    if @entity
      data = @entity[:sprite]
      @filename = data.filename
      texture = TextureCache.resource @filename
      @sprite = Moon::Sprite.new(texture)
      #@sprite.clip_rect = Moon::Rect.new(0, 0, 32, 32)
      @sprite.clip_rect = Moon::Rect.new(0, 0, 0, 0).set(data.clip_rect)
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
      charpos = t.position * @tilesize + [x, y, z]
      #@blok.render(*charpos, 1)

      sx = charpos.x + (@tilesize.x - @sprite.w) / 2
      sy = charpos.y + (@tilesize.y - @sprite.h) / 2
      sz = charpos.z
      @sprite.render(sx, sy, sz)
      @mp_gauge.render(charpos.x, sy, sz, options)
      @hp_gauge.render(charpos.x, sy - @mp_gauge.h, sz, options)

      s.bounds ||= Moon::Cuboid.new
      s.bounds.set(sx, sy, sz, @sprite.w, @sprite.h, 1)
      #@border_renderer.border_rect = bounds.to_rect_xy
      #@border_renderer.render(bounds.x, bounds.y, bounds.z)
    end
  end
end