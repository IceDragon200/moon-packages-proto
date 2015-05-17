class MapEditorMapController < State::ControllerBase
  attr_accessor :gui_controller

  def refresh_map
    @view.refresh_tilemaps
  end

  def refresh_layer_opacity
    @view.refresh_layer_opacity
  end

  def layer_opacity=(lop)
    @model.layer_opacity = lop
    refresh_layer_opacity
  end

  def toggle_grid(enabled)
    @model.show_grid = enabled
    @view.refresh_grid
  end
end
