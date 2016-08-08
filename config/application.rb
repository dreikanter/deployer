require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Deployer
  class Application < Rails::Application
    config.autoload_paths += %w(app lib).map { |p| Rails.root.join p }

    config.active_job.queue_adapter = :sidekiq

    def smtp_enable_starttls_auto
      ENV['smtp_enable_starttls_auto'].to_s.casecmp('true').zero?
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.smtp_settings = {
      user_name:            ENV['smtp_user_name'],
      password:             ENV['smtp_password'],
      address:              ENV['smtp_address'],
      domain:               ENV['smtp_domain'],
      enable_starttls_auto: smtp_enable_starttls_auto,
      authentication:       ENV['smtp_authentication'],
      port:                 ENV['smtp_port']
    }

    config.action_mailer.default_url_options = {
      host: ENV['action_mailer_url_host'],
      port: ENV['action_mailer_url_port']
    }

    config.generators do |g|
      g.test_framework :minitest, spec: false, fixture: false
      g.helper       false
      g.decorator    false
      g.assets       false
      g.stylesheets  false
      g.javascripts  false
      g.view_specs   false
      g.helper_specs false
      g.skip_routes  true
    end

    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      params = event.payload[:params].except('controller', 'action')
      { params: params } unless params.empty?
    end
  end
end
