# Based on https://github.com/ssaunier/github_webhook
module GithubWebhook
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_github_request!, only: :create
    before_action :check_github_event!, only: :create
    before_action :check_handler!, only: :create
  end

  class SignatureError < StandardError; end
  class UnspecifiedWebhookSecretError < StandardError; end
  class UnsupportedGithubEventError < StandardError; end
  class UnsupportedContentTypeError < StandardError; end

  GITHUB_EVENTS_WHITELIST = %w(
    ping
    commit_comment
    create
    delete
    deployment
    deployment_status
    download
    follow
    fork
    fork_apply
    gist
    gollum
    issue_comment
    issues
    member
    membership
    page_build
    public
    pull_request
    pull_request_review_comment
    push
    release
    repository
    status
    team_add
    watch
  ).freeze

  def create
    return unless respond_to?(event_method)
    send(event_method, json_body)
    head(:ok)
  end

  def github_ping(payload)
    logger.info "Ping received, hook_id: #{payload[:hook_id]}, #{payload[:zen]}"
  end

  private

  def hmac_digest
    @hmac_digest ||= OpenSSL::Digest.new('sha1').freeze
  end

  def authenticate_github_request!
    return if signature_header == expected_signature
    raise SignatureError,
      "Actual: #{signature_header}, Expected: #{expected_signature}"
  end

  def signature_header
    @signature_header ||= request.headers['X-Hub-Signature']
  end

  def expected_signature
    "sha1=#{hexdigest(webhook_secret)}"
  end

  def hexdigest(secret)
    OpenSSL::HMAC.hexdigest(hmac_digest, secret, request_body)
  end

  def check_github_event!
    event = request.headers['X-GitHub-Event']
    return if GITHUB_EVENTS_WHITELIST.include?(event)
    raise UnsupportedGithubEventError,
      "#{event} is not a whiltelisted GitHub event"
  end

  def request_body
    @request_body ||= request_body_contents
  end

  def request_body_contents
    request.body.rewind
    request.body.read
  end

  def json_body
    @json_body ||=
      ActiveSupport::HashWithIndifferentAccess.new(JSON.load(json_payload))
  end

  def json_payload
    return parse_request_body_payload if x_www_form_urlencoded?
    return request_body if application_json?
    raise UnsupportedContentTypeError, "Content-Type #{content_type}"
  end

  def parse_request_body_payload
    Rack::Utils.parse_query(request_body)['payload']
  end

  def content_type
    @content_type ||= request.headers['Content-Type']
  end

  def x_www_form_urlencoded?
    content_type == 'application/x-www-form-urlencoded'
  end

  def application_json?
    content_type == 'application/json'
  end

  def check_handler!
    return if respond_to?(event_method)
    raise NoMethodError, "#{event_method} not implemented"
  end

  def event_method
    @event_method ||= "github_#{request.headers['X-GitHub-Event']}".to_sym
  end

  def webhook_secret
    ENV['github_webhook_secret']
  end
end
