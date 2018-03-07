require 'animation/transition_host'

class TransitionScheduler
  include Moon::TransitionHost

  alias :create :create_transition
  alias :add :add_transition
  alias :remove :remove_transition
  alias :finish :finish_transitions

  def update(delta)
    update_transitions delta
  end
end
