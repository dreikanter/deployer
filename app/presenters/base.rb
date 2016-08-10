# NOTE: Derived classes should have Presenter suffix due to the Rails auto load
# gotcha: Rails wont autoload namespaced class if there is another class with
# the same name in root namespace. Which is true for Presenters.

module Presenters
  class Base < SimpleDelegator
    attr_reader :model
    attr_reader :view

    include ActionView::Helpers::UrlHelper

    def initialize(model, view)
      @model = model
      @view = view
      super(@model)
    end

    def h
      @view
    end

    def not_implemented!
      throw NotImplementedError
    end
  end
end
