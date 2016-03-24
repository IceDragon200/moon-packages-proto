require 'std/event'
require 'lunar_ui/widget'

module Lunar
  class Button < Widget
    class ButtonEvent < Moon::Event
      attr_reader :button

      def initialize(button, type)
        @button = button
        super type
      end
    end

    # @return [Moon::Label]
    attr_reader :label

    #
    def initialize_elements
      super
      @label = Moon::Label.new
      add(@label)
    end

    def initialize_widget_events
      super
      initialize_button_events
    end

    def initialize_button_events
      on :press do |e|
        if e.button == :mouse_left && screen_bounds.contains?(e.position)
          trigger { ButtonEvent.new(self, :button_press) }
        end
      end

      on :release do |e|
        if e.button == :mouse_left && screen_bounds.contains?(e.position)
          trigger { ButtonEvent.new(self, :button_release) }
        end
      end
    end
  end
end
