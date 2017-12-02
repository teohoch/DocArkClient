class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_root_url

  def set_root_url
    $root_url = root_url
  end

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

  def get_current_session
    if session.has_key? :current_session and not JSON.parse(session[:current_session]).blank?
      JSON.parse(session[:current_session]).symbolize_keys
    else
      nil
    end
  end
end
