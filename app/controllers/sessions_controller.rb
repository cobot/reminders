class SessionsController < ApplicationController
  skip_before_filter :require_user
  before_action :show_header

  def new
  end

  def create
    user = AuthenticationService.new.call auth_hash
    self.current_user = user
    redirect_to spaces_path
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
