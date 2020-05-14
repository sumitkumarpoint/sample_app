module Api::V1
  class UserWebsiteUrlsController < ApplicationController
    before_action :user_website_url, only: [:show, :update, :destroy]
    before_action :authenticate_user!, except: [:show, :index]
    before_action :accessible_user!, except: [:show, :index, :get_university]
    before_action :user_profile ,only: [:show,:index]

    # GET /v1/public_profile/:user_slug/website_urls
    def index
      # abort @user.inspect
      if @user_profile.present?
        @user_website_urls = @user_profile.user_website_urls.paginate(page: params[:page], per_page: PAGE_COUNT)
      end

      render_success_response({
                                  user_website_urls: array_serializer.new(@user_website_urls, serializer: UserWebsiteUrlSerializer)}, '', 200, {
                                  pagination: SerializeHelper.pagination_dict(@user_website_urls)
                              })
    end

    # GET /v1/public_profile/:user_slug/website_urls/1
    def show
      render json: @user_website_url
      render_success_response({
                                  user_website_url: single_serializer(@user_website_url, UserWebsiteUrlSerializer)
                              })
    end

    # POST /v1/public_profile/:user_slug/website_urls
    def create
      if current_user.user_profile.present?
        user_profile = current_user.user_profile
      else
        user_profile = UserProfile.create(:user_id => current_user.id)
      end
      user_website_url_data                   = user_website_url_params
      user_website_url_data[:user_profile_id] = user_profile.id if user_profile.present?
      @user_website_url                       = UserWebsiteUrl.new(user_website_url_data)

      if @user_website_url.save
        render_success_response({
                                    user_website_url: single_serializer(@user_website_url, UserWebsiteUrlSerializer)
                                }, I18n.t('common.created', model: 'Education'))
      else
        render_unprocessable_entity_response(@user_website_url)
      end
    end

    # PATCH/PUT /v1/public_profile/:user_slug/website_urls/1
    def update
      if @user_website_url.update(user_website_url_params)
        render_success_response({
                                    user_website_url: single_serializer(@user_website_url, UserWebsiteUrlSerializer)
                                }, I18n.t('common.updated', model: 'Education'))
      else
        render_unprocessable_entity_response(@user_website_url)
      end
    end

    # DELETE /v1/public_profile/:user_slug/website_urls/1
    def destroy
      @user_website_url.destroy
      render_success_response({
                                  user_website_url: single_serializer(@user_website_url, UserWebsiteUrlSerializer)
                              }, I18n.t('common.deleted', model: 'Website URL'))
    end

    # POST /v1/public_profile/:user_slug/skills
    def update_skills
      user_skill_data = []
      user_skill_params[:user_skill].each do |k, v|
        user_skill_data.push(v)
      end
      user_skills    = current_user.user_profile.user_skills
      user_skill_ids = user_skills.pluck(:id)
      @user_skills   = user_skills.create(JSON.parse(user_skill_data.to_json))
      if @user_skills
        UserSkill.delete(user_skill_ids)
        render_success_response({
                                    user_skills: array_serializer.new(@user_skills, serializer: UserSkillSerializer)},
                                I18n.t('common.updated', model: 'Skills'), 200, {})
      else
        render_unprocessable_entity_response(@user_skills[0])
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def user_website_url
      @user_website_url = UserWebsiteUrl.find_by(:id => params[:id])
      unless @user_website_url.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Website URL'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_skill_params
      params.permit(user_skill: [:id, :name, :user_profile_id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_website_url_params
      params.require(:user_website_url).permit(:id,:provider, :url, :user_profile_id)
    end
  end
end
