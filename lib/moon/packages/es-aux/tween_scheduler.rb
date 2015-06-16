class TweenScheduler
  class Result
    def put(value)
      @value = value
      @callback.call(value) if @callback
    end

    def get
      @value
    end

    def hook(&callback)
      @callback = callback
    end
  end

  # @return [Moon::Scheduler] scheduler
  attr_reader :scheduler

  # @param [Moon::Scheduler] scheduler
  def initialize(scheduler)
    @scheduler = scheduler
  end

  # @param [Hash<Symbol, Object>] options
  # @option options [.call] :easer
  # @option options [Object] :to
  # @option options [Object] :from
  # @option options [String, Float] :duration
  def tween(options)
    easer    = options.fetch(:easer) { Moon::Easing::Linear }
    from     = options.fetch(:from)
    to       = options.fetch(:to)
    duration = options.fetch(:duration)
    diff = to - from

    result = Result.new
    job = @scheduler.run_for duration do |_, j|
      # job times are counted down, we have to invert it for easing
      result.put from + diff * easer.call(1.0 - [[0, j.rate].max, 1.0].min)
    end
    job.on :done do
      result.put to
    end
    job.tag 'tween'
    result
  end

  # @param [Object] obj  target object to tween
  # @param [String, Symbol] property  the property that should be tweened
  # @param [Hash<Symbol, Object>] options
  def tween_obj(obj, property, options)
    getter = property
    setter = "#{property}="
    result = tween({ from: obj.dotsend(getter) }.merge(options))
    result.hook do |v|
      obj.dotsend(setter, v)
    end
    result
  end
end
