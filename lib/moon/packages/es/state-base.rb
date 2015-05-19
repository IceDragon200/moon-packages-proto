# Container module for all States in ES based games
module States
  # Base class for all ES based states
  class Base < ::State
    include StateMiddlewarable
    middleware SchedulerMiddleware
    middleware InputMiddleware
    include Moon::TransitionHost

    attr_reader :updatables
    attr_reader :renderables
    attr_reader :tree

    class CVar
      def initialize
        @data = {}
      end

      def clear
        @data.clear
      end

      def [](key)
        @data[key]
      end

      def []=(key, value)
        @data[key] = value
      end
    end

    @@__cvar__ = CVar.new

    # @return [CVar]
    def cvar
      @@__cvar__
    end

    # @return [Moon::Eventable]
    def input
      middleware(InputMiddleware).handle
    end

    # @return [Moon::Scheduler]
    def scheduler
      middleware(SchedulerMiddleware).scheduler
    end

    def init
      super
      @updatables = []
      @renderables = []
      @renderer = Moon::RenderContainer.new
      @gui = Moon::RenderContainer.new
      @tree = Moon::Tree.new

      @tree.add @renderer
      @tree.add @gui

      @updatables << @renderer
      @updatables << @gui
      @renderables << @renderer
      @renderables << @gui

      register_default_events
      register_input
    end

    private def register_default_events
      register_default_input_events
    end

    private def register_default_input_events
      input.on :any do |e|
        @renderer.input.trigger e
        @gui.input.trigger e
        @debug_shell.input.trigger e if @debug_shell
      end

      input.on :press do |e|
        case e.key
        when :left_bracket
          @scheduler.p_job_table
        when :right_bracket
          @debug_shell ? stop_debug_shell : launch_debug_shell
        when :f12
          state_manager.pop
          state_manager.push self.class
        end
      end
    end

    private def register_input
      #
    end

    def launch_debug_shell
      @debug_shell = DebugShell.new(FontCache.font('uni0553', 16))
      @debug_shell.position.set(0, 0, 0)
    end

    def stop_debug_shell
      @debug_shell = nil
    end

    # @param [Float] delta
    def update(delta)
      @updatables.each do |element|
        element.update delta
      end
      update_transitions delta
      super delta
    end

    def render
      GC.disable
      @renderables.each do |element|
        element.render
      end
      @debug_shell.render if @debug_shell
      super
    ensure
      GC.enable
    end
  end
end
