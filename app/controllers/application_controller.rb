class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  before_filter :require_user

  def current_user
    User.find session[:user_id] if session[:user_id]
  end

  def current_user=(user)
    session[:user_id] = user.id
  end

  def require_user
    unless current_user
      redirect_to '/auth/cobot'
    end
  end
end
