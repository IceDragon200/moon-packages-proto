module States
  # A generic splash will display an image on a white background.
  # The image will fade in and then fade out.
  # Note that the screen.clear_color will be tweened to white, if it
  # is not white.
  class GenericSplash < Splash
    def init
      super
      @foreground = Moon::Sprite.new(splash_texture).to_sprite_context
      @foreground.position.x = (screen.w - @foreground.w) / 2
      @foreground.position.y = (screen.h - @foreground.h) / 2
      @foreground.sprite.opacity = 0.0
      @renderer.add @foreground
    end

    def start
      super
      t = TweenScheduler.new(scheduler)
      d = '1s 500'
      e = Moon::Easing::BackOut

      scheduler.in '100' do
        t.tween_obj screen, :clear_color, to: Moon::Vector4.new(1.0, 1.0, 1.0, 1.0), duration: d, easer: e
        scheduler.in d do
          t.tween_obj @foreground.sprite, :opacity, to: 1.0, duration: d, easer: e
          scheduler.in d.to_duration * 2 do
            t.tween_obj @foreground.sprite, :opacity, to: 0.0, duration: d, easer: e
            scheduler.in d do
              self.finish
            end
          end
        end
      end
    end

    def early_finish
      screen.clear_color = Moon::Vector4.new(1.0, 1.0, 1.0, 1.0)
      super
    end
  end
end
