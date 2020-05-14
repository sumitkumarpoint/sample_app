class ApplicationController < ActionController::API
  respond_to :json
  include ResourceRenderer
  before_action :set_mailer_host_with_port
  def set_mailer_host_with_port
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def user_profile
    @user_profile=User.find_by(:slug => params[:user_slug]).user_profile
    unless @user_profile.present?
      render_unprocessable_entity(I18n.t('common.not_fount',model: "Profile"))
    end
  end

  def accessible_user!
    @user=User.find_by(:slug => params[:user_slug])
    unless current_user.id == @user.id
      render_unprocessable_entity(I18n.t('common.unauthorised'))
    end
  end
  def sign_in_and_redirect_devise(resource_or_scope, *args)
    options  = args.extract_options!
    scope    = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope
    sign_in(scope, resource, options)
    # redirect_to after_sign_in_path_for(resource)
  end
end
