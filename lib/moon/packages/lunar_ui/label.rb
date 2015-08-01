require 'lunar_ui/widget'

module Lunar
  class Label < Widget
    # @return [Moon::Label]
    attr_reader :label

    #
    def initialize_elements
      super
      @label = Label.new
      add @label
    end
  end
end
