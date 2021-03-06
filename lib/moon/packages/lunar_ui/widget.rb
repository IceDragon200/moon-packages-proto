require 'render_primitives/render_container'

module Lunar
  # Widget base class
  class Widget < Moon::RenderContainer
    # @return [Boolean]
    attr_accessor :focused
    # @return [Moon::SkinSlice9]
    attr_reader :background

    #
    def initialize_members
      @focused = false
      super
    end

    #
    protected def initialize_elements
      super
      create_background
    end

    #
    protected def initialize_events
      super
      initialize_widget_events
    end

    private def initialize_widget_events
      on :resize do
        @background.w = w
        @background.h = h
      end
    end

    #
    private def create_background
      @background = Moon::SkinSlice9.new
      add(@background)
    end

    #
    def focus
      @focused = true
    end

    #
    def unfocus
      @focused = false
    end
  end
end
