module States
  class MoonSplash < GenericSplash
    def splash_texture
      Moon::Texture.new 'resources/splash/moon_logo.png'
    end
  end
end
