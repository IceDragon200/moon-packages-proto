require 'es_map_editor/models/map_editor_model'
require 'state_mvc/model_binder'

class MapEditorModelBinder < State::ModelBinder
  schema MapEditorModel, :model

  def start
  end

  def update(delta)
    cam_cursor.update delta
    camera.update delta
  end
end
