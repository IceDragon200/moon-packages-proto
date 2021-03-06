# Container module for all States in ES based games
module States
  # Base class for all ES based states
  class Base < ::State
    attr_reader :input
    attr_reader :scheduler
    attr_reader :input_list
    attr_reader :render_list
    attr_reader :update_list
    attr_reader :transition

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

    def on_exception(exc, backtrace)
      STDERR.puts exc.inspect
      backtrace.each_with_index do |line, i|
        STDERR.puts "\t[#{backtrace.size - i}] #{line}"
      end
      fail
    end

    protected def create_render_contexts
      @renderer = Moon::RenderContainer.new
      @renderer.tag 'renderer'
      @gui = Moon::RenderContainer.new
      @gui.tag 'gui'
    end

    def init
      super
      @update_list = []
      @render_list = []
      @input_list = []

      @scheduler = Moon::Scheduler.new
      @transition = TransitionScheduler.new
      @input = Moon::Input::Observer.new
      @input.on_exception = ->(exc, backtrace) { on_exception(exc, backtrace) }

      create_render_contexts

      @input_list << @renderer
      @input_list << @gui
      @update_list << @scheduler
      @update_list << @transition
      @update_list << @renderer
      @update_list << @gui
      @render_list << @renderer
      @render_list << @gui

      register_default_events
      register_input
    end

    def terminate
      super
      puts "Terminating State: #{self}"
      @scheduler.clear
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
      @update_list << @debug_shell
      @render_list << @debug_shell
    end

    def stop_debug_shell
      @update_list.delete @debug_shell
      @render_list.delete @debug_shell
      @debug_shell = nil
    end

    # @param [Float] delta
    def update(delta)
      @update_list.each do |element|
        element.update delta
      end
      super
    end

    def render
      GC.disable
      @render_list.each do |element|
        element.render
      end
    ensure
      GC.enable
    end

    # @param [Float] delta
    def step(delta)
      unless @started
        start
        @started = true
      end
      # game logic
      update delta
      render
    end
  end
end
