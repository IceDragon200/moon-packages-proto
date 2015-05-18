class MapEditorModel < State::ModelBase
  field :map,                    type: ES::EditorMap,         default: nil
  field :camera_move_speed,      type: Moon::Vector2,         default: proc{ |t| t.model.new(8, 8) }
  field :camera,                 type: Camera2,               default: nil
  field :cam_cursor,             type: CameraCursor2,         default: proc{ |t| t.model.new }
  field :map_cursor,             type: MapCursor,             default: proc{ |t| t.model.new }
  field :selection_rect,         type: Moon::Rect,            default: proc{ |t| t.model.new(0,0,0,0) }
  field :selection_stage,        type: Integer,               default: 0
  field :layer,                  type: Integer,               default: 1
  array :layer_opacity,          type: Float,                 default: proc{ [1.0, 1.0] }
  field :layer_count,            type: Integer,               default: 2
  field :zoom,                   type: Float,                 default: 1.0
  field :flag_show_chunk_labels, type: Boolean,               default: false
  field :keyboard_only_mode,     type: Boolean,               default: false
  field :show_grid,              type: Boolean,               default: false
  field :tile_palette,           type: ES::EditorTilePalette, default: proc{ |t| t.model.new }

  def save
    data = @model.export
    data.camera = nil
    YAML.save_file('editor.yml', data)
  end
end
