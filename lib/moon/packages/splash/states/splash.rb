module States
  class Splash < Base
    def init
      super
      register_cancel_inputs
    end

    def register_cancel_inputs
      input.on :press do |e|
        early_finish if [:escape, :c, :enter].include?(e.key)
      end
    end

    def early_finish
      finish
    end

    def finish
      state_manager.pop
    end
  end
end
