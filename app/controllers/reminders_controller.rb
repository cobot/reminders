class RemindersController < ApplicationController
  helper_method :space

  def index
    if space.reminders.any?
      @reminders = space.reminders
    else
      redirect_to new_space_reminder_path(space)
    end
  end

  def new
    @reminder = Reminder.new
  end

  def edit
    @reminder = space.reminders.find params[:id]
  end

  def create
    @reminder = space.reminders.build params[:reminder]
    if params[:commit] == 'Preview'
      render 'preview'
    else
      if @reminder.save
        redirect_to space_reminders_path(space)
      else
        render 'new'
      end
    end
  end

  def update
    @reminder = space.reminders.find params[:id]
    @reminder.attributes = params[:reminder]
    if @reminder.save
      redirect_to space_reminders_path(space), notice: 'Reminder changed.'
    else
      render 'edit'
    end
  end

  def destroy
    reminder = space.reminders.find params[:id]
    reminder.destroy
    redirect_to space_reminders_path(space), notice: 'Reminder removed.'
  end

  private

  def space
    @space ||= current_user.spaces.find{|space| space.to_param == params[:space_id]}
  end
end
