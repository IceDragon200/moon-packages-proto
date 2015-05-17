require 'moon-logfmt/load'

class MiddlewareManager
  attr_reader :state

  EMPTY = []

  def initialize(state)
    @logger = Moon::Logfmt::Logger.new ctx: 'MiddlewareManager'
    @state = state
    reset
  end

  def reset
    @middlewares = []
    @middleware_registry = {}
    @middleware_hooks = {}
  end

  def refresh
    l = @logger.new state: state.to_s
    l.write msg: 'Refreshing Middlewares'
    @middlewares.each do |middleware_klass|
      ll = l.new middleware: middleware_klass
      ll.write msg: "Refreshing Middleware"
      middleware = middleware_klass.new(state)
      middleware.logger = ll
      @middleware_registry[middleware_klass] = middleware
      middleware.hooks.each do |hook|
        ll.write hook: hook, msg: 'Adding hook'
        (@middleware_hooks[hook] ||= []).push(middleware)
      end
    end
  end

  def setup(middlewares)
    reset
    @middlewares = middlewares
    refresh
  end

  def [](klass)
    @middleware_registry[klass]
  end

  def trigger(hook, *args)
    (@middleware_hooks[hook] || EMPTY).each do |middleware|
      ## update hooks are noisy
      #unless hook.to_s.include?('update')
      #  @logger.write middleware: middleware.to_s, hook: hook, msg: 'Running Hook'
      #end
      middleware.trigger_hook(hook, *args)
    end
  end
end

module Middlewarable
  class ReinitializationError < RuntimeError
  end

  module ClassMethods
    prototype_attr :middleware

    def middleware(klass)
      middlewares << klass
    end
  end

  attr_reader :middleware_manager

  def initialize(*args, &block)
    initialize_middleware
    super(*args, &block)
  end

  private def initialize_middleware
    if @middleware_manager # re-initialization!
      raise ReinitializationError, "MiddlewareManager was already initialized!"
    end
    @middleware_manager = MiddlewareManager.new(self)
    @middleware_manager.setup self.class.all_middlewares
  end

  def middleware(klass)
    @middleware_manager[klass]
  end
end

module StateMiddlewarable
  include Middlewarable

  def self.hook_method(name)
    define_method name do |*args, &block|
      super(*args, &block)
      @middleware_manager.trigger(name, *args)
    end
  end

  hook_method :init
  hook_method :start
  hook_method :pause
  hook_method :resume
  hook_method :terminate
  hook_method :pre_update
  hook_method :update
  hook_method :post_update
  hook_method :pre_render
  hook_method :render
  hook_method :post_render

  def self.included(mod)
    mod.extend ClassMethods
  end
end

class EventHopper
  def initialize(target)
    @target = target
  end

  def trigger(event)
    @target << event
  end

  alias :call :trigger
end

class BaseMiddleware
  attr_accessor :logger
  attr_reader :state

  def initialize(state)
    @logger = Moon::Logfmt::NullLogger
    @state = state
  end

  def trigger_hook(hook, *args, &block)
    public_send(hook, *args, &block)
  end

  def hooks
    @hooks ||= self.class.hooks
  end

  def self.hooks
    @hooks ||= []
  end

  def self.hook(method_name)
    if method_name.is_a?(Hash)
      method_name.each do |key, target|
        key = key.to_sym
        target = target.to_sym
        define_method(key) { |*args, &block| send(target, *args, &block) }
        hooks << key
      end
    else
      hooks << method_name
    end
  end
end

class InputMiddleware < BaseMiddleware
  attr_reader :handle

  private def setup_exception_handler
    return unless state.respond_to?(:on_exception)
    exh = ->(exc, backtrace) { state.on_exception(exc, backtrace) }
    @handle.on_exception = exh
  end

  hook def init
    @handle = Moon::Input::Observer.new
    setup_exception_handler
  end
end

class SchedulerMiddleware < BaseMiddleware
  attr_reader :scheduler

  hook def init
    @scheduler = Moon::Scheduler.new
  end

  hook def pre_update(delta)
    @scheduler.update delta
  end
end
