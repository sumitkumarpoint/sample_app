class ConfirmationsController < Devise::ConfirmationsController
	respond_to :json
  include ResourceRenderer

  def show
  	self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      sign_in(resource)
			render_success_response({
        user: single_serializer(resource, UserSerializer)
      }, "User confirmed successfully")
	  else
	  	render_unprocessable_entity_response(resource)
	  end
  end

  def create
    @user = User.where(:email => params[:email]).first
    if @user && @user.confirmed_at.nil?
      @user.send_confirmation_instructions
      render_success_response({}, I18n.t('devise.confirmations.resend_confirmed'))
    else
      render_unprocessable_entity_response(@user, I18n.t('devise.failure.resend_confirmed'))
    end
  end
end
