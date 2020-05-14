class OmniauthCallbacksController < ApplicationController
  respond_to :json
  include ResourceRenderer
  def common_auth2
    # abort params['auth'].inspect
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    user = User.from_omniauth(params['auth'])

    if user.persisted?
      sign_in_and_redirect_devise user, event: :authentication
      render_success_response({
                                  user: single_serializer(user, UserSerializer, user: user)
                              }, "Successfully logged in")

    else
      render_unprocessable_entity("Invalid #{user_name_or_email.capitalize} or Password")
    end

  end

end
