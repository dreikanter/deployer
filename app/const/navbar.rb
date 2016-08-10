module Const
  class Navbar
    MENU = [
      {
        caption: 'Deployment keys',
        path: Rails.application.routes.url_helpers.deployment_keys_path,
        controller: 'deployment_keys'
      },
      {
        caption: 'Sample item',
        path: '#',
        controller: ''
      }
    ].freeze
  end
end
