module Lunar
  ##
  # Widget base class
  class Widget < Moon::RenderContainer
    # @return [Boolean]
    attr_accessor :focused
    # @return [Moon::SkinSlice9]
    attr_reader :background

    ##
    #
    def init
      @focused = false
      super
    end

    ##
    #
    private def initialize_elements
      super
      create_background
    end

    ##
    #
    private def initialize_events
      super
      initialize_widget_events
    end

    private def initialize_widget_events
      on :resize do
        @background.w = w
        @background.h = h
      end
    end

    ##
    #
    private def create_background
      @background = Moon::SkinSlice9.new
      add(@background)
    end

    ##
    #
    def focus
      @focused = true
    end

    ##
    #
    def unfocus
      @focused = false
    end
  end
end
