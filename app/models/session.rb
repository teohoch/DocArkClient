class Session
  include ActiveModel::Model
  attr_accessor :app_id, :app_secret, :url, :access_token, :callback, :scopes

  def initialize(options=nil)
    super(options)
    @scopes = @scopes.nil? ? %w(read write delete) :
                  @scopes.kind_of?(Array) ? @scopes : @scopes.split(' ')
    @client = OAuth2::Client.new(@app_id, @app_secret, site: @url)
    @callback = URI.join($root_url, Rails.application.routes.url_helpers.oauth_callback_path)
  end

  def authorize
    URI.unescape(@client.auth_code.authorize_url(redirect_uri: @callback.to_s, scope: @scopes.join('+' )))
  end

  def get_access_token(code)
    @access_token = @client.auth_code.get_token(code, redirect_uri: @callback.to_s)
  end

  def to_json_string
    temp = {app_id: @app_id,
            app_secret: @app_secret,
            url: @url,
            callback: @callback.to_s,
            scopes: @scopes
    }
    unless @access_token.nil?
      temp[:access_token] = {
          expires_at: @access_token.expires_at,
          token: @access_token.token,
          refresh_token: @access_token.refresh_token
      }
    end
    temp.to_json
  end
end