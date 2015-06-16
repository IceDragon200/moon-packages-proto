require 'es-aux/sprite_context'

module Moon
  class Sprite
    def to_sprite_context
      prx = SpriteContext.new
      prx.sprite = self
      prx
    end
  end
end
