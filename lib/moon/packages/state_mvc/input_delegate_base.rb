class State
  #
  class InputDelegateBase
    attr_accessor :engine

    # @param [State::ControllerBase] controller
    def initialize(engine, controller)
      @engine = engine
      @controller = controller
      init
    end

    # @abstract
    def init
      #
    end

    # @param [Moon::Input::Observer, Moon::Eventable] input
    def register(input)
      #
    end
  end
end
