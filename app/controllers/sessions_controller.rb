class SessionsController < ApplicationController
  skip_before_filter :require_user

  def new
  end

  def create
    user = AuthenticationService.new.call auth_hash
    self.current_user = user
    redirect_to spaces_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
