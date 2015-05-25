require 'lunar_ui/widget'

module Lunar
  class Label < Widget
    # @return [Moon::Text]
    attr_reader :text

    #
    def initialize_elements
      super
      @text = Text.new
      add @text
    end
  end
end
