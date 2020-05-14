class PasswordsController < Devise::PasswordsController
  respond_to :json
  include ResourceRenderer

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render_success_response({}, "Sent mail for forgot password")
    else
      render_unprocessable_entity_response(resource,"")
    end
  end

  def update
  	self.resource = resource_class.reset_password_by_token(resource_params)
  	if resource.errors.empty?
			render_success_response([], "Password reset successfully")
	  else
	  	render_unprocessable_entity_response(resource, "Reset password token is invalid")
	  end
  end
end