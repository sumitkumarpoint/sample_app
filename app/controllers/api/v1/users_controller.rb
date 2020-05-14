module Api::V1
  class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user!,except: [:public_profile]
    def activities
      user=User.find_by(:slug=>params[:user_slug])
      @activities = PublicActivity::Activity.where(:owner_id=>user.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      render_success_response({
                                  activities: array_serializer.new(@activities, serializer: ActivitiesSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@advertisement_comments)
                              })

    end

    def public_profile
      # abort current_user.inspect
      @user=User.find_by(:slug=>params[:slug])
      if @user.present?
        @user.profile_viewers.find_or_create_by(:viewer_id=>current_user.id) if current_user.present? && current_user.id != @user.id
        render_success_response({
                                    user: single_serializer(@user, UserSerializer,user_profile: true)
                                }, "User profile matched")
      else
        render_unprocessable_entity("Invalid user id")
      end
    end
    def save_profile
        if current_user.user_profile.present?
          user_profile=current_user.user_profile
          @user_profile=user_profile.update(user_profile_params)
        else
          @user_profile=UserProfile.new(user_profile_params)
          @user_profile.user_id=current_user.id
          user_profile=@user_profile
          @user_profile.save
        end
        if params[:user].present?
          current_user.update(user_params)
          bypass_sign_in(current_user)
        end

      if @user_profile
        render_success_response({
                                    user: single_serializer(current_user, UserSerializer,user_profile: true)
                                }, "User profile updated")
      else
        render_unprocessable_entity_response(@user_profile)
      end
    end
    private
    def user_profile_params
      params.require(:user_profile).permit(:id,:first_name,:last_name,:birth_date,:profile_image,:cover_image,:location,:website,:current_position,:industry,:serving_notice_period,:last_working_date,:language,:user_skills_attributes=>[:id,:name,:user_profile_id,:_destroy])
    end
    def user_params
      params.require(:user).permit(:id,:email,:password,:phone)
    end
  end
end
