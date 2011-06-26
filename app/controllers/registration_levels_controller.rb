class RegistrationLevelsController < ApplicationController
  def index
    @registration_level = RegistrationLevel.all
  end

  def apply
    session[:registration_level] = params[:id]
    redirect_to new_winery_registration_path
  end

end
