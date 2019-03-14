class SpacesController < ApplicationController
  before_action :show_header, only: :index

  def index
    redirect_to space_reminders_path(current_user.spaces.first)
  end
end
