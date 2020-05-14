module Api::V1
  class AdvertisementCommentsController < ApplicationController
    before_action :set_advertisement_comment, only: [:show, :update, :destroy]
    before_action :authenticate_user!, except: [:index]
    # GET /advertisements/:post_slug/advertisement_comments
    def index
      @advertisement_comments = Advertisement.includes(:advertisement_comments).find_by(:slug => params[:advertisement_slug]).advertisement_comments.paginate(page: params[:page], per_page: PAGE_COUNT)

      render_success_response({
                                  advertisement_comments: array_serializer.new(@advertisement_comments, serializer: AdvertisementCommentSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@advertisement_comments)
                              })
    end

    # GET /advertisements/:advertisement_slug/advertisement_comments/1
    def show
      # render json: @advertisement_comment
      render_success_response({
                                  advertisement_comment: single_serializer(@advertisement_comment, AdvertisementCommentSerializer)
                              })
    end

    # POST /advertisements/:advertisement_slug/advertisement_comments
    def create
      # abort advertisement_comment_params.inspect
      advertisement = Advertisement.find_by(:slug => params[:advertisement_slug])
      if advertisement.present?
        advertisement_comment_data         = advertisement_comment_params
        advertisement_comment_data[:user_id] = current_user.id
        advertisement_comment_data[:advertisement_id] = advertisement.id
        @advertisement_comment             = AdvertisementComment.new(advertisement_comment_data)

        if @advertisement_comment.save
          advertisement.create_activity key: 'advertisement.commented_on', owner: current_user
          render_success_response({
                                      advertisement_comment: single_serializer(@advertisement_comment, AdvertisementCommentSerializer)
                                  }, I18n.t('common.created', model: 'Comment'))
        else
          render_unprocessable_entity_response(@advertisement_comment)
        end
      else
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Advertisement'))
      end
    end

    # PATCH/PUT /advertisements/:advertisement_slug/advertisement_comments/1
    def update
      advertisement = Advertisement.find_by(:slug => params[:advertisement_slug])
      if advertisement.present?
      if @advertisement_comment.user_id == current_user.id && @advertisement_comment.update(advertisement_comment_params)
        render_success_response({
                                    advertisement_comment: single_serializer(@advertisement_comment, AdvertisementCommentSerializer)
                                }, I18n.t('common.updated', model: 'Comment'))
      else
        render_unprocessable_entity_response(@advertisement_comment)
      end
      else
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Post'))
      end
    end

    # DELETE /advertisements/:advertisement_slug/advertisement_comments/1
    def destroy
      advertisement = Advertisement.find_by(:slug => params[:advertisement_slug])
      if advertisement.present?
        @activity = PublicActivity::Activity.find_by(key: 'advertisement.commented_on',owner_id: current_user.id,trackable_id: advertisement.id, trackable_type: "Advertisement")
        @activity.destroy
      end
      @advertisement_comment.destroy
      render_success_response({
                                  advertisement_comment: single_serializer(@advertisement_comment, AdvertisementCommentSerializer)
                              }, I18n.t('common.deleted', model: 'Comment'))
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_advertisement_comment
      @advertisement_comment = AdvertisementComment.find_by(:id=>params[:id])
      unless @advertisement_comment.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Comment'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def advertisement_comment_params
      params.require(:advertisement_comment).permit(:id, :content,:advertisement_comment_attachments_attributes=>[:id,:media,:advertisement_comment_id,:_destroy])
    end
  end
end
