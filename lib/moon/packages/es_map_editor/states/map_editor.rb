require 'es_map_editor/bindings/map_editor_model_binder'

module States
  # Built-in Map Editor for editing ES-Moon style maps and chunks
  class EsMapEditor < States::Base
    attr_reader :model
    attr_reader :controller
    attr_reader :view

    def init
      super
      @tp_clock = Moon::Clock.new

      create_mvc
      create_input_delegate
      create_world
      create_map
      create_autosave_interval

      input.ppd_ev
    end

    def start
      super
      #@map_controller.refresh_follow
      @gui_controller.refresh_follow
      @map_controller.start
      @gui_controller.start

      @model.notify_all

      # debug
      scheduler.print_jobs
      @model.ppd_ev
    end

    private def create_model
      view = engine.screen.rect
      view = view.translate(-(view.w / 2), -(view.h / 2))
      data = File.exist?('editor.yml') ? YAML.load_file('editor.yml') : {}
      @model = MapEditorModelBinder.new(model: MapEditorModel.new(data))
      @model.camera = Camera2.new(view: view)
      @model.tile_palette.tileset = ES::Tileset.find_by(uri: '/tilesets/common')
      @model.layer ||= -1
    end

    private def create_view
      @map_view = MapEditorMapView.new(model: @model, view: engine.screen.rect)
      @gui_view = MapEditorGuiView.new(model: @model, view: engine.screen.rect.contract(16))
      tileset = @model.tile_palette.tileset
      texture = TextureCache.tileset(tileset.filename)
      @gui_view.tileset = Moon::Spritesheet.new(texture, tileset.cell_w,
                                                         tileset.cell_h)
      @renderer.add @map_view
      @gui.add @gui_view
    end

    private def create_controller
      @map_controller = MapEditorMapController.new engine, @model, @map_view
      @gui_controller = MapEditorGuiController.new engine, @model, @gui_view
      @gui_controller.map_controller = @map_controller
      @map_controller.gui_controller = @gui_controller
      @updatables.push @map_controller
      @updatables.push @gui_controller
    end

    private def create_mvc
      create_model
      create_view
      create_controller
    end

    private def create_input_delegate
      @router = MapEditorInputDelegate.new engine, @gui_controller

      input.on(:any) do |e|
        @router.input.trigger e
        @gui_view.input.trigger e
        @map_view.input.trigger e
      end

      input.on(:mousemove) do |e|
        @gui_controller.set_cursor_position_from_mouse(e.position)
      end
    end

    private def create_world
      @world = Moon::EntitySystem::World.new
      @updatables.unshift @world
    end

    private def create_map
      map = ES::Map.find_by(uri: '/maps/school/f1')
      @model.map = map.to_editor_map
      @model.map.chunks = map.chunks.map do |chunk_head|
        chunk = ES::Chunk.find_by(uri: chunk_head.uri)
        editor_chunk = chunk.to_editor_chunk
        editor_chunk.position = chunk_head.position
        editor_chunk.tileset = ES::Tileset.find_by(uri: chunk.tileset.uri)
        editor_chunk
      end
    end

    private def create_autosave_interval
      @autosave_interval = scheduler.every('3m') do
        @gui_controller.autosave
      end.tag('autosave')
    end

    private def update_world(delta)
      @world.update(delta)
    end

    def update(delta)
      update_world(delta)
      super delta
    end
  end
end
