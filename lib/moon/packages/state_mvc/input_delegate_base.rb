require 'std/input'
require 'std/mixins/eventable'

class State
  #
  class InputDelegateBase
    include Moon::Eventable

    # @return [Moon::Engine]
    attr_accessor :engine

    # @return [Moon::Input::Observer]
    attr_accessor :input

    # @param [State::ControllerBase] controller
    def initialize(engine, controller)
      @engine = engine
      @controller = controller
      @input = Moon::Input::Observer.new
      init
      register_events
    end

    # @abstract
    def init
    end

    # @abstract
    def register_events
    end
  end
end
