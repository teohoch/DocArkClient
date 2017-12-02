class SessionController < ApplicationController
  def login
    if get_current_session.nil?
      @session = Session.new
    else
      @current_session = get_current_session
    end

  end

  def authorize
    if (session_params.keys & %w(app_id app_secret url)).size == 3
      temp = Session.new(session_params)
      if temp.valid?
        session[:current_session] = temp.to_json_string
        @redirect_url = temp.authorize
      else
        render new_session_path, error: t('session.missing_params')
      end
    else
      render root_path, error: t('session.missing_params')
    end
  end

  def logout
    session[:current_session] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  def callback
    temp = Session.new(get_current_session)
    temp.get_access_token(callback_params[:code])
    session[:current_session] = temp.to_json_string
    @current_session = get_current_session
    redirect_to root_path, notice: "Successfully initialized session with #{temp.url}"
  end

  private

  def session_params
    params.require(:session).permit(:app_id, :app_secret,:url)
  end

  def callback_params
    params.permit( :code)
  end

end
