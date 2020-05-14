# Creation - Parth Joshi - 17-07-2019
# Updation - Parth Joshi - 09-07-2019
# Definition: Registration Controller
class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  include ResourceRenderer

  def create
    build_resource(sign_up_params)
    if resource.save
      render_success_response({
         user: single_serializer(resource, UserSerializer)
      }, "User Created")
    else
      render_unprocessable_entity_response(resource)
    end
  end
  private
    def sign_up_params
      params.require(:user).permit(:email, :password, :phone, :name, :password_confirmation, :username)
    end
end