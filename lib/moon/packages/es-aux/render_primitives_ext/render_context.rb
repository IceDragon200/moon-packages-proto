require 'es-aux/taggable'

module Moon
  class RenderContext
    include ES::Taggable

    def everyone
      return to_enum :everyone unless block_given?
      yield self
    end
  end

  class RenderContainer
    def everyone(&block)
      return to_enum :everyone unless block_given?
      yield self
      @elements.each do |e|
        e.everyone(&block)
      end
    end
  end
end
