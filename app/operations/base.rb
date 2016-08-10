module Operations
  class Base
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def self.call(params = {})
      operation = new(params)
      operation.perform
      operation
    end
  end
end
