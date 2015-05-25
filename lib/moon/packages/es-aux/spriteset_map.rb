class SpritesetMap < Moon::RenderContainer
  attr_reader :dm_map
  attr_reader :tilesize
  attr_reader :world

  def initialize_members
    super
    @dm_map = nil
    @world = nil
  end

  def initialize_content
    super
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

  def initialize_events
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
