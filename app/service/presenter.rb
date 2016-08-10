class Presenter
  class << self
    def for(object, options = {}, &block)
      return if object.nil?
      presentation = class_for(object, options).new(object, self.view(options))
      block_given? and yield(presentation) or presentation
    end

    def map(objects, options = {})
      objects.map { |o| self.for(o, options) }
    end

    def class_for(object, options = {})
      return options[:class] if options[:class]
      "#{scope(options)}::#{object.class.name}Presenter".constantize
    end

    def view(options)
      options[:view] || ActionController::Base.helpers
    end

    def scope(options)
      "Presenters#{('::' + options[:scope]) if options[:scope]}"
    end
  end
end
