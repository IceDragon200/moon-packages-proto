require 'render_primitives/render_context'

# Specialized renderer for rendering Map Chunks
class ChunkRenderer < Moon::RenderContext
  attr_reader :chunk

  def init
    super
    @tilemap = Moon::Tilemap.new
    @size = Moon::Vector3.new(1, 1, 1)
  end

  def w
    @tilemap.w
  end

  def h
    @tilemap.h
  end

  def layer_opacity
    @tilemap.layer_opacity
  end

  def layer_opacity=(layer_opacity)
    @tilemap.layer_opacity = layer_opacity
  end

  def refresh_position
    self.position = @chunk.position * @size
  end

  def refresh
    tileset = @chunk.tileset
    @texture = TextureCache.tileset(tileset.filename)
    @tilemap.tileset = Moon::Spritesheet.new(@texture, tileset.cell_w,
                                                       tileset.cell_h)
    @tilemap.data = @chunk.data
    @size = Moon::Vector3.new(tileset.cell_w, tileset.cell_h, 1)
    refresh_position
  end

  def chunk=(chunk)
    @chunk = chunk
    refresh
  end

  def update_content(delta)
    refresh_position
  end

  def render_content(x, y, z, options)
    @tilemap.render(x, y, z, options)
  end
end
