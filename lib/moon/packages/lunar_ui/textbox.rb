require 'lunar_ui/widget'

module Lunar
  #
  class Textbox < Widget
    # @!attribute [r] text
    #   @return [Moon::Label]
    attr_reader :text

    #
    protected def initialize_elements
      super
      @text = Moon::Label.new
      add @text
    end

    #
    protected def initialize_events
      super
      input.on :typing do |e|
        @text.string += e.char
      end

      on :clear do
        @text.string.clear
      end

      input.on :press do |e|
        @text.string = @text.string.chop if e.key == :backspace
      end

      on :resize do
        @text.position.y = (h - @text.line_height) / 2
      end
    end
  end
end
