require 'std/event'
require 'lunar_ui/widget'

module Lunar
  class Button < Widget
    class ButtonEvent < Moon::Event
      attr_reader :button

      def initialize(button, key)
        @button = button
        super key
      end
    end

    class PressEvent < ButtonEvent
      def initialize(button)
        super button, :button_press
      end
    end

    class DepressEvent < ButtonEvent
      def initialize(button)
        super button, :button_depress
      end
    end

    # @return [Moon::Text]
    attr_reader :text

    ##
    #
    def initialize_elements
      super
      @text = Text.new
      add(@text)
    end

    def initialize_widget_events
      super
      initialize_button_events
    end

    def initialize_button_events
      on :press, :mouse_left do |e|
        trigger PressEvent.new(self) if screen_bounds.contains?(e.position)
      end

      on :release, :mouse_left do |e|
        trigger DepressEvent.new(self) if screen_bounds.contains?(e.position)
      end
    end
  end
end
