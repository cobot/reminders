class SpacesController < ApplicationController
  def index
    redirect_to space_reminders_path(current_user.spaces.first)
  end
end
