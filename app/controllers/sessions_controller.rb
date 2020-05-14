class SessionsController < Devise::SessionsController
  respond_to :json
  include ResourceRenderer
  # updated the sign in method
  def create
    session.clear
    user_name_or_email = user_name_or_email?(login_params[:email]) ? "email" : "username"
    user               = user_name_or_email == "email" ? User.unscoped.find_by_email(login_params[:email].downcase) : User.unscoped.find_by_username(login_params[:email])

    if user && user.valid_password?(login_params[:password])
      #checking user's account is active or not
      # if user.is_active? # && user.confirmed?
        render_success_response({
                                    user: single_serializer(user, UserSerializer, user: user)
                                }, "Successfully logged in")
        # else
        #   render_false_response user
      # end
    else
      render_unprocessable_entity("Invalid #{user_name_or_email.capitalize} or Password")
    end
  end



  private
  def login_params
    params.require(:user).permit(:email, :password)
  end

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :ok
  end

  def user_name_or_email?(email)
    email =~ URI::MailTo::EMAIL_REGEXP ? true : false
  end

  def user_name_or_email
    login_params[:email]
  end
end
