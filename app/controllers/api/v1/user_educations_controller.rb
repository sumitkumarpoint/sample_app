module Api::V1
  class UserEducationsController < ApplicationController
    before_action :user_education, only: [:show, :update, :destroy]
    before_action :authenticate_user!, except: [:show, :index]
    before_action :accessible_user!, except: [:show, :index, :get_university]
    before_action :user_profile ,only: [:show,:index,:get_skills]
    def get_university
      require 'net/http'

      url = URI.parse("http://universities.hipolabs.com/search?name=#{params[:name]}")
      req = Net::HTTP.get(url)
      abort req.inspect
      res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
      }
      puts res.body
      abort res.inspect
    end

    # GET /v1/public_profile/:user_slug/educations
    def index
      # abort @user.inspect
      if @user_profile.present?
        @user_educations = @user_profile.user_educations.paginate(page: params[:page], per_page: PAGE_COUNT)
      end

      render_success_response({
                                  user_educations: array_serializer.new(@user_educations, serializer: UserEducationSerializer)}, '', 200, {
                                  pagination: SerializeHelper.pagination_dict(@user_educations)
                              })
    end

    # GET /v1/public_profile/:user_slug/educations/1
    def show
      render json: @user_education
      render_success_response({
                                  user_education: single_serializer(@user_education, UserEducationSerializer)
                              })
    end

    # POST /v1/public_profile/:user_slug/educations
    def create
      if current_user.user_profile.present?
        user_profile = current_user.user_profile
      else
        user_profile = UserProfile.create(:user_id => current_user.id)
      end
      user_education_data                   = user_education_params
      user_education_data[:user_profile_id] = user_profile.id if user_profile.present?
      @user_education                       = UserEducation.new(user_education_data)

      if @user_education.save
        render_success_response({
                                    user_education: single_serializer(@user_education, UserEducationSerializer)
                                }, I18n.t('common.created', model: 'Education'))
      else
        render_unprocessable_entity_response(@user_education)
      end
    end

    # PATCH/PUT /v1/public_profile/:user_slug/educations/1
    def update
      if @user_education.update(user_education_params)
        render_success_response({
                                    user_education: single_serializer(@user_education, UserEducationSerializer)
                                }, I18n.t('common.updated', model: 'Education'))
      else
        render_unprocessable_entity_response(@user_education)
      end
    end

    # DELETE /v1/public_profile/:user_slug/educations/1
    def destroy
      @user_education.destroy
      render_success_response({
                                  user_education: single_serializer(@user_education, UserEducationSerializer)
                              }, I18n.t('common.deleted', model: 'Education'))
    end

    # GET /v1/public_profile/:user_slug/skills
    def get_skills

      if @user_profile.present?
        @user_skills = @user_profile.user_skills.paginate(page: params[:page], per_page: PAGE_COUNT)
      end

      render_success_response({
                                  user_skills: array_serializer.new(@user_skills, serializer: UserSkillSerializer)}, '', 200, {
                                  pagination: SerializeHelper.pagination_dict(@user_skills)
                              })
    end

    # POST /v1/public_profile/:user_slug/skills
    def update_skills
      user_skill_data = []
      if user_skill_params[:user_skill].present?
        user_skill_params[:user_skill].each do |k, v|
          user_skill_data.push(v)
        end
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
    def user_education
      @user_education = UserEducation.find_by(:id => params[:id])
      unless @user_education.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Education'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_skill_params
      params.permit(user_skill: [:id, :name, :user_profile_id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_education_params
      params.require(:user_education).permit(:id, :university, :website_url, :location, :degree, :starting_from, :ending_in, :details, :user_profile_id)
    end
  end
end
