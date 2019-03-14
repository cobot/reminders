class WelcomeController < ApplicationController
  skip_before_action :authenticate, :allow_in_iframe
  before_action :show_header

  def show
  end
end
