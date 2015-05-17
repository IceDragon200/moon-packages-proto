require 'std/mixins/transition_host'

class MapEditorMapView < State::ViewBase
  include Moon::TransitionHost

  def start
    super
    refresh_tilemaps
  end

  def initialize_view
    super
    @tileselection_rect = ES::UI::SelectionTileRect.new
    @map_renderer = EditorMapRenderer.new
    @map_cursor = MapCursorRenderer.new
    texture  = TextureCache.block 'e032x032.png'
    @cursor_ss  = Moon::Spritesheet.new texture, 32, 32
    color = DataCache.palette['system/selection']
    @tileselection_rect.spritesheet = @cursor_ss
    @tileselection_rect.color = color

    create_passage_layer

    add @map_renderer
    add @map_cursor
  end

  private def create_passage_layer
    t = @passage_tilemap = Moon::Tilemap.new
    t.position.set 0, 0, 0
    t.tileset = @passage_ss
    t.data = @passage_data # special case passage data
  end

  def refresh_layer_opacity
    src = @map_renderer.layer_opacity.dup
    dest = @model.layer_opacity.dup
    add_transition 0, 1, 0.25 do |d|
      dest.each_with_index do |n, i|
        @map_renderer.layer_opacity[i] = src[i].lerp(n, d)
      end
    end
  end

  def refresh_tilemaps
    @map_renderer.dm_map = @model.map
    refresh_layer_opacity
  end

  def refresh_grid
    @map_renderer.show_underlay = @model.show_grid
  end

  def update_content(delta)
    show_labels = @model.flag_show_chunk_labels
    campos = -@model.camera.view_offset.floor
    pos = @model.map_cursor.position * @model.camera.tilesize + campos
    @map_cursor.position.set pos.x, pos.y, 0
    @map_renderer.show_borders = show_labels
    @map_renderer.show_labels = show_labels
    refresh_grid
    @map_renderer.position.set(campos.x, campos.y, 0)
    super
  end

  def render_edit_mode
    campos = @model.camera.view_offset.floor
    if @model.selection_stage > 0
      @tileselection_rect.render(*(-campos))
    end
  end

  def render_content(x, y, z, options)
    render_edit_mode
    super
  end
end
