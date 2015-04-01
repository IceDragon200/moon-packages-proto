module States
  class Splash < Base
    def register_cancel_inputs
      [:c, :enter].each do |key|
        input.on Moon::KeyboardEvent, action: :press, key: key do
          early_finish
        end
      end
    end
  end
end
