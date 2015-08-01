# Container module for all States in ES based games
module States
  # Base class for all ES based states
  class Base < ::State
    include StateMiddlewarable
    middleware SchedulerMiddleware
    include Moon::TransitionHost

    attr_reader :input
    attr_reader :input_list
    attr_reader :render_list
    attr_reader :tree
    attr_reader :update_list

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

    # @return [Moon::Scheduler]
    def scheduler
      middleware(SchedulerMiddleware).scheduler
    end

    def on_exception(exc, backtrace)
      STDERR.puts exc.inspect
      backtrace.each_with_index do |line, i|
        STDERR.puts "\t[#{backtrace.size - i}] #{line}"
      end
      fail
    end

    def init
      super
      @update_list = []
      @render_list = []
      @input_list = []

      @input = Moon::Input::Observer.new
      exh = ->(exc, backtrace) { on_exception(exc, backtrace) }
      @input.on_exception = exh

      @renderer = Moon::RenderContainer.new
      @renderer.tag 'renderer' if @renderer.respond_to?(:tag)
      @gui = Moon::RenderContainer.new
      @gui.tag 'gui' if @gui.respond_to?(:tag)
      @tree = Moon::Tree.new

      @tree.add @renderer
      @tree.add @gui

      @input_list << @renderer
      @input_list << @gui
      @update_list << @renderer
      @update_list << @gui
      @render_list << @renderer
      @render_list << @gui

      register_default_events
      register_input
    end

    def terminate
      super
      @tree.clear_children
      @input_list.clear
      @update_list.clear
      @render_list.clear
    end

    private def register_default_events
      register_default_input_events
    end

    private def register_default_input_events
      input.on :any do |e|
        if @debug_shell
          @debug_shell.input.trigger e
        else
          @input_list.each do |elm|
            elm.input.trigger e
          end
        end
      end

      input.on :press do |e|
        case e.key
        when :left_bracket
          scheduler.print_jobs
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
      @debug_shell = DebugShell.new
      @debug_shell.resize(screen.w, @debug_shell.h)
      @debug_shell.position.set(0, 0, 0)
    end

    def stop_debug_shell
      @debug_shell = nil
    end

    # @param [Float] delta
    def update(delta)
      @update_list.each do |element|
        element.update delta
      end
      @debug_shell.update delta if @debug_shell
      update_transitions delta
      super
    end

    def render
      GC.disable
      @render_list.each do |element|
        element.render
      end
      @debug_shell.render if @debug_shell
      super
    ensure
      GC.enable
    end
  end
end
