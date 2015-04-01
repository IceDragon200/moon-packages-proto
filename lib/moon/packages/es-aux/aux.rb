class String
  def to_duration
    Moon::TimeUtil.parse_duration(self)
  end
end

module Moon
  class Scheduler
    module Jobs
      class Base
        include ES::Taggable
      end
    end
    #def print_jobs
    #  table = []
    #  colsizes = [0, 0, 0, 0]
    #  @jobs.each do |job|
    #    # job type, time, duration
    #    row = [job.class.to_s, job.time.to_s, job.duration.to_s, job.tags.to_s]
    #    row.size.times do |i|
    #      size = row[i].size
    #      colsizes[i] = size if colsizes[i] < size
    #    end
    #    table << row
    #  end
    #  format = colsizes.map { |i| "%-0#{i}s" }.join('    ')
    #  puts sprintf(format, 'Job', 'Time', 'Duration', 'Tag')
    #  table.each do |row|
    #    puts sprintf(format, *row)
    #  end
    #end

    def print_jobs
      table = []
      l = Logfmt::Logger.new(module: 'scheduler')
      l.timestamp = false
      @jobs.each do |job|
        case job
        when Moon::Scheduler::Jobs::TimeBase
          l.write(job: job.class.to_s.demodulize,
                  time: "#{job.time}/#{job.duration}",
                  tags: job.tags)
        else
          l.write(job: job.class.to_s.demodulize,
                  tags: job.tags)
        end
      end
    end
  end
end

module Moon
  class Sprite
    def to_proxy_sprite
      prx = ProxySprite.new
      prx.sprite = self
      prx
    end
  end
end

class AssetManager
  def initialize
    @map = {}
  end

  def [](ref)
    @map[ref]
  end

  def get(ref)
    @map.fetch(ref)
  end
end

class ObjectFactpry
  attr_reader :asset_manager

  def initialize(asset_manager)
    @asset_manager = asset_manager
  end

  def sprite(ref)
    Moon::Sprite.new(@asset_manager.get(ref))
  end

  def spritesheet(ref, cw, ch)
    Moon::Spritesheet.new(@asset_manager.get(ref), cw, ch)
  end
end

class ProxySprite < Moon::RenderContext
  attr_accessor :sprite

  def width
    (@sprite && @sprite.width) || 0
  end

  def height
    (@sprite && @sprite.height) || 0
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
    super
  end
end

module Moon
  class RenderContext
    include ES::Taggable

    def everyone
      [self]
    end
  end
  class RenderContainer
    def everyone
      ([self] + @elements.map(&:everyone)).flatten
    end
  end
end

class TweenScheduler
  class Result
    def put(value)
      @value = value
      @callback.call(value) if @callback
    end

    def get
      @value
    end

    def hook(&callback)
      @callback = callback
    end
  end

  # @return [Moon::Scheduler] scheduler
  attr_reader :scheduler

  # @param [Moon::Scheduler] scheduler
  def initialize(scheduler)
    @scheduler = scheduler
  end

  # @param [Hash<Symbol, Object>] options
  # @option options [.call] :easer
  # @option options [Object] :to
  # @option options [Object] :from
  # @option options [String, Float] :duration
  def tween(options)
    easer    = options.fetch(:easer) { Moon::Easing::Linear }
    from     = options.fetch(:from)
    to       = options.fetch(:to)
    duration = options.fetch(:duration)
    diff = to - from

    result = Result.new
    job = @scheduler.run_for duration do |_, j|
      # job times are counted down, we have to invert it for easing
      result.put from + diff * easer.call(1.0 - [[0, j.rate].max, 1.0].min)
    end
    job.on_done = proc do
      result.put to
    end
    job.tag 'tween'
    result
  end

  # @param [Object] obj  target object to tween
  # @param [String, Symbol] property  the property that should be tweened
  # @param [Hash<Symbol, Object>] options
  def tween_obj(obj, property, options)
    getter = property
    setter = "#{property}="
    result = tween({ from: obj.dotsend(getter) }.merge(options))
    result.hook do |v|
      obj.dotsend(setter, v)
    end
    result
  end
end

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

    @base_sprite.ox = @base_sprite.width / 2
    @base_sprite.oy = @base_sprite.height
    @bar_sprite.ox = @bar_sprite.width / 2
    @bar_sprite.oy = @bar_sprite.height

    self.width = @base_sprite.width
    self.height = @base_sprite.height
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
      rect.width = @gauge_texture.width * @rate
      @bar_sprite.clip_rect = rect
    end
  end
end

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
      @sprite.ox = @sprite.width / 2
      @sprite.oy = @sprite.height / 2
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
    super
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
      @hp_gauge.render(charpos.x, sy - @mp_gauge.height, sz, options)

      bounds = Moon::Cuboid.new(sx, sy, sz, @sprite.width, @sprite.height, 1)
      s.bounds = bounds
      #@border_renderer.border_rect = bounds.to_rect_xy
      #@border_renderer.render(bounds.x, bounds.y, bounds.z)
    end
    super
  end
end

class SpritesetMap < Moon::RenderContainer
  attr_reader :dm_map
  attr_reader :tilesize
  attr_reader :world

  def init
    super
    @dm_map = nil
    @world = nil
    @map_renderer = EditorMapRenderer.new
    @entities = Moon::RenderArray.new
    @tilesize = Moon::Vector3.new(32, 32, 32)

    add @map_renderer
    add @entities
  end

  private def add_entity(entity)
    entity_r = EntityRenderer.new
    entity_r.tilesize = @tilesize
    entity_r.entity = entity
    @entities.add entity_r
  end

  private def remove_entity(entity)
    @entities.reject! { |r| r.entity == entity }
  end

  def init_events
    super
    on :entity_added do |e|
      add_entity e.entity
    end

    on :entity_removed do |e|
      remove_entity e.entity
    end
  end

  def refresh_world
    @entities.clear
    @world.entities.each do |entity|
      add_entity entity
    end
  end

  def dm_map=(dm_map)
    @dm_map = dm_map
    @map_renderer.dm_map = @dm_map
  end

  def world=(world)
    @world = world
    refresh_world
  end

  def tilesize=(tilesize)
    @tilesize = tilesize
    @entities.each { |e| e.tilesize = @tilesize }
  end
end

module Team
  enum_const :NEUTRAL, :ALLY, :ENEMY, :COUNT
end
