class TscOauth
  def initialize(app_id, app_secret, url)
    @app_id = app_id
    @app_secret = app_secret
    @url = url
    @callback = Rails.application.routes.url_helpers.authorization_path
  end

  def authorize
    client = OAuth2::Client.new(@app_id, @app_secret, site: @url)
    client.auth_code.authorize_url(redirec_uri: @callback)
  end
end