module States
  class Splash < Base
    def init
      super
      register_cancel_inputs
    end

    def register_cancel_inputs
      input.on :press, :escape, :c, :enter do
        early_finish
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
