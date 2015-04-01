module ES
  module Taggable
    attr_writer :tags

    def tags
      @tags ||= []
    end

    def tag(*args)
      tags.concat args
    end

    def untag(*args)
      self.tags -= args
    end
  end

  class Tags
    include Taggable
  end
end
