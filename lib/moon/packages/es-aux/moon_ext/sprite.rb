require 'es-aux/proxy_sprite'

module Moon
  class Sprite
    def to_proxy_sprite
      prx = ProxySprite.new
      prx.sprite = self
      prx
    end
  end
end
