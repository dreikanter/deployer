module Operations
  module DeploymentKey
    class Index < Operations::Base
      attr_reader :records
      attr_reader :form

      def perform
        @form = DeploymentKeyForm.new(::DeploymentKey.new)
        @records = ::DeploymentKey.all
      end
    end
  end
end
