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

    def self.actions?
      const_defined?('ACTIONS')
    end

    def self.columns?
      const_defined?('COLUMNS')
    end

    def self.record?
      const_defined?('RECORD')
    end

    def self.actions
      actions? && self::ACTIONS || []
    end

    def self.columns
      columns? && self::COLUMNS || []
    end

    def self.record
      record? && self::RECORD || []
    end
  end
end
