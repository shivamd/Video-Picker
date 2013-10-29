class ApplicationsController < ApplicationController
  before_filter :authenticate_user! 

  def new 
    @application = current_user.applications.build
  end

  def create
    @application = current_user.applications.build(application_params)
    unless @application.save
      render :new, notice: "Unable to create application, please try again later"
    else
      redirect_to applications_path, notice: "Successfully created application"
    end
  end

  def index
    @applications = current_user.applications
  end

  private

  def application_params
    params.require(:application).permit(:name)
  end
end
