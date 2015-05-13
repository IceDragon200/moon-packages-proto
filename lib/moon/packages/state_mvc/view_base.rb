##
# :nodoc:
class State
  ##
  #
  class ViewBase < Moon::RenderContainer
    # @return [State::ModelBase]
    attr_accessor :model

    # @return [Moon::Rect]
    attr_accessor :view

    ##
    # @param [Hash<Symbol, Object>] options
    private def init_from_options(options)
      super
      @model = options.fetch(:model, nil)
      @view = options.fetch(:view)
    end

    ##
    #
    private def init
      super
      init_view
    end

    ##
    # @abstract
    def start
      # called by State::ControllerBase
    end

    ##
    # @abstract
    def init_view
      #
    end
  end
end
