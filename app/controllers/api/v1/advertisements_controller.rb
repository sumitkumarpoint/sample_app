module Api::V1
  class AdvertisementsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]
    before_action :authenticate_user!
    # GET /advertisements
    def index
      @advertisements = Advertisement.includes(:advertisement_comments, :advertisement_shares, :advertisement_likes).paginate(page: params[:page], per_page: PAGE_COUNT)

      render_success_response({
                                  advertisements: array_serializer.new(@advertisements, serializer: AdvertisementSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@advertisements)
                              })

    end

    # GET /advertisements/1
    def show
      render_success_response({
                                  advertisement: single_serializer(@advertisement, AdvertisementSerializer)
                              })
    end

    # POST /advertisements
    def create
      # abort Advertisement.new(advertisement_params).inspect
      @advertisement = Advertisement.new(advertisement_params)
      # abort @advertisement.errors.inspect
      if @advertisement.save
        @advertisement.create_activity key: 'advertisement.created', owner: current_user
        render_success_response({
                                    advertisement: single_serializer(@advertisement, AdvertisementSerializer)
                                }, I18n.t('common.created', model: 'Advertisement'))
      else
        render_unprocessable_entity_response(@advertisement)
      end
    end

    # PATCH/PUT /advertisements/1
    def update
      if @advertisement.update(advertisement_params)
        render_success_response({
                                    advertisement: single_serializer(@advertisement, AdvertisementSerializer)
                                }, I18n.t('common.updated', model: 'Advertisement'))
      else
        render_unprocessable_entity_response(@advertisement)
      end
    end

    # DELETE /advertisements/1
    def destroy
      @advertisement.destroy
      @activity = PublicActivity::Activity.where(trackable_id: @advertisement.id, trackable_type: "Advertisement")
      @activity.destroy_all
      render_success_response({
                                  advertisement: single_serializer(@advertisement, AdvertisementSerializer)
                              }, I18n.t('common.deleted', model: 'Advertisement'))
    end

    # POST /advertisements/:advertisement_slug/like_dislike
    def like_dislike
      advertisement=Advertisement.find_by(:slug=>params[:advertisement_slug])
      if advertisement.present?
        @advertisement_like  = AdvertisementLike.find_by(:user_id => current_user.id, :advertisement_id => advertisement.id)
        @advertisement_likes = AdvertisementLike.where(:advertisement_id => advertisement.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      if @advertisement_like.present?
        if AdvertisementLike.destroy(@advertisement_like.id)
          @activity = PublicActivity::Activity.find_by(key: 'advertisement.liked',owner_id: current_user.id,trackable_id: advertisement.id, trackable_type: "Advertisement")
          @activity.destroy
          render_success_response({
                                      advertisement_likes: array_serializer.new(@advertisement_likes, serializer: AdvertisementLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@advertisement_likes)
                                  })
        else
          render_unprocessable_entity_response(@advertisement_like)
        end
      else
        @advertisement_like = AdvertisementLike.new(:user_id => current_user.id, :advertisement_id => advertisement.id)
        if @advertisement_like.save
          advertisement.create_activity key: 'advertisement.liked', owner: current_user
          render_success_response({
                                      advertisement_likes: array_serializer.new(@advertisement_likes, serializer: AdvertisementLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@advertisement_likes)
                                  })
        else
          render_unprocessable_entity_response(@advertisement_like)
        end
      end
    end

    # POST /advertisements/:advertisement_slug/share
    def share
      advertisement=Advertisement.find_by(:slug=>params[:advertisement_slug])
      if advertisement.present?
        @advertisement_share  = AdvertisementShare.find_by(:user_id => current_user.id, :advertisement_id => advertisement.id)
        @advertisement_shares = AdvertisementShare.where(:advertisement_id => advertisement.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      # unless @advertisement_share.present?
        @advertisement_share = AdvertisementShare.new(:user_id => current_user.id, :advertisement_id => advertisement.id)
        if @advertisement_share.save
          render_success_response({
                                      advertisement_shares: array_serializer.new(@advertisement_shares, serializer: AdvertisementShareSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@advertisement_shares)
                                  })
        else
          render_unprocessable_entity_response(@advertisement_share)
        end
      # else
      #   render json: @advertisement_shares
      # end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @advertisement = Advertisement.find_by(:slug=>params[:slug])
      unless @advertisement.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Advertisement'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def advertisement_params
      # params.fetch(:post, {})
      params.require(:advertisement).permit(:id, :campaign_name, :objective, :budget_type, :budget_amount, :start_date, :end_date, :age_from, :age_to, :gender, :media_type, :media, :primary_text, :website_url, :call_to_action, :user_id,:advertisement_skills_attributes=>[:id,:name,:advertisement_id,:_destroy],:advertisement_job_roles_attributes=>[:id,:name,:advertisement_id,:_destroy],:advertisement_locations_attributes=>[:id,:country,:state,:city,:advertisement_id,:_destroy])
    end

  end
end
