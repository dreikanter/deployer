module ViewBuilders
  class Base
    attr_reader :view
    attr_reader :options
    alias_method :h, :view

    def initialize(view, options = {})
      @view, @options = view, options
    end

    def html
      fail NotImplementedError
    end

    def presenter
      options[:presenter] || derived_presenter
    end

    def derived_presenter
      object = options[:record] || options[:records].first
      Presenter.class_for(object, scope: presenter_scope)
    end

    def presenter_scope
      options[:presenter_scope]
    end

    def records
      options[:records] || []
    end

    def record
      @record ||= presented(options[:record])
    end

    def default_empty_text
      ''
    end

    def empty_text
      options[:empty] || default_empty_text
    end

    def presented(object)
      return presenter_for(object, class: presenter) if presenter
      return presenter_for(object, scope: presenter_scope) if presenter_scope
      object
    end

    def presenter_for(object, options = {})
      Presenter.for(object, options.merge(view: view))
    end

    def empty_placeholder
      h.content_tag :div, empty_text, class: 'emptyness text-muted'
    end
  end
end
