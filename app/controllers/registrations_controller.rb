class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    new_application_path
  end

  def after_sign_in_path_for(resource)
    new_application_path
  end
end
