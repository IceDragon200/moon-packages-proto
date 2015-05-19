# Generic Map Cursor renderer
class MapCursorRenderer < Moon::RenderContext
  def init
    super
    @texture = TextureCache.ui('map_editor_cursor.png')
    @sprite = Moon::Sprite.new(@texture)
  end

  def render_content(x, y, z, options)
    @sprite.render x, y, z
  end
end
