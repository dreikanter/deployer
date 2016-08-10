module Presenters
  class DeploymentKeyPresenter < Presenters::Base
    ACTIONS = [
      {
        title: 'Open',
        path: -> (r) { r.path_to_self },
        method: :get
      },
      {
        title: 'Rename',
        path: -> (r) { r.path_to_edit_self },
        method: :get
      },
      {
        title: 'Delete',
        path: -> (r) { r.path_to_self_js },
        remote: true,
        method: :delete,
        data: { confirm: 'Are you sure you want to delete this record?' }
      }
    ].freeze

    COLUMNS = [
      {
        title: 'id',
        value: -> (r) { r.id },
        classes: 'min-width'
      },
      {
        title: 'name',
        value: -> (r) { r.name }
      },
      {
        title: 'created_at',
        value: -> (r) { r.created_at },
        classes: 'min-width nowrap'
      }
    ].freeze

    def path_to_self
      h.deployment_key_path(model)
    end

    def path_to_self_js
      h.deployment_key_path(model, format: :js)
    end

    def path_to_edit_self
      h.edit_deployment_key_path(model)
    end
  end
end
