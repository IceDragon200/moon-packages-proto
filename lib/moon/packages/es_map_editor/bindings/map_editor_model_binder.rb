require 'es_map_editor/models/map_editor_model'
require 'state_mvc/model_binder'

class MapEditorModelBinder < State::ModelBinder
  bind_model MapEditorModel, :model

  def update_model(delta)
    cam_cursor.update delta
    camera.update delta
  end
end
