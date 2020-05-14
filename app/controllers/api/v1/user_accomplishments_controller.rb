module Api::V1
  class UserAccomplishmentsController < ApplicationController
    before_action :user_accomplishment, only: [:show, :update, :destroy]
    before_action :authenticate_user!, except: [:show, :index]
    before_action :accessible_user!, except: [:show, :index]
    before_action :user_profile ,only: [:show,:index]

    # GET /v1/public_profile/:user_slug/educations
    def index
      # abort @user.inspect
      if @user_profile.present?
        @user_accomplishments = @user_profile.user_accomplishments.paginate(page: params[:page], per_page: PAGE_COUNT)
      end

      render_success_response({
                                  user_accomplishments: array_serializer.new(@user_accomplishments, serializer: UserAccomplishmentSerializer)}, '', 200, {
                                  pagination: SerializeHelper.pagination_dict(@user_accomplishments)
                              })
    end

    # GET /v1/public_profile/:user_slug/educations/1
    def show
      render json: @user_accomplishment
      render_success_response({
                                  user_accomplishment: single_serializer(@user_accomplishment, UserAccomplishmentSerializer)
                              })
    end

    # POST /v1/public_profile/:user_slug/educations
    def create
      if current_user.user_profile.present?
        user_profile = current_user.user_profile
      else
        user_profile = UserProfile.create(:user_id => current_user.id)
      end
      user_accomplishment_data                   = user_accomplishment_params
      user_accomplishment_data[:user_profile_id] = user_profile.id if user_profile.present?
      @user_accomplishment                       = UserAccomplishment.new(user_accomplishment_data)

      if @user_accomplishment.save
        render_success_response({
                                    user_accomplishment: single_serializer(@user_accomplishment, UserAccomplishmentSerializer)
                                }, I18n.t('common.created', model: 'Accomplishment'))
      else
        render_unprocessable_entity_response(@user_accomplishment)
      end
    end

    # PATCH/PUT /v1/public_profile/:user_slug/educations/1
    def update
      if @user_accomplishment.update(user_accomplishment_params)
        render_success_response({
                                    user_accomplishment: single_serializer(@user_accomplishment, UserAccomplishmentSerializer)
                                }, I18n.t('common.updated', model: 'Accomplishment'))
      else
        render_unprocessable_entity_response(@user_accomplishment)
      end
    end

    # DELETE /v1/public_profile/:user_slug/educations/1
    def destroy
      @user_accomplishment.destroy
      render_success_response({
                                  user_accomplishment: single_serializer(@user_accomplishment, UserAccomplishmentSerializer)
                              }, I18n.t('common.deleted', model: 'Accomplishment'))
    end



    private

    # Use callbacks to share common setup or constraints between actions.
    def user_accomplishment
      @user_accomplishment = UserAccomplishment.find_by(:id => params[:id])
      unless @user_accomplishment.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Accomplishment'))
      end
    end



    # Only allow a trusted parameter "white list" through.
    def user_accomplishment_params
      params.require(:user_accomplishment).permit(:id, :category, :award_organization, :website, :location, :award, :date_received, :user_profile_id)
    end
  end
end
