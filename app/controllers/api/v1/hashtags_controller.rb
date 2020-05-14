module Api::V1
  class HashtagsController < ApplicationController
    before_action :set_hashtag, only: [:show, :update, :destroy]
    # before_action :authenticate_user!
    # GET /hashtags
    def index

      @hashtags = Hashtag.paginate(page: params[:page], per_page: PAGE_COUNT)

      render_success_response({
                                  hashtags: array_serializer.new(@hashtags, serializer: HashtagSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@hashtags)
                              })

    end

    # GET /hashtags/1
    def show
      hashtag_viewers= @hashtag.Hashtag_viewers.find_or_create_by(:viewer_id=>current_user.id) if current_user.present? && current_user.id != @hashtag.user_id
      render_success_response({
                                  hashtag: single_serializer(@hashtag, HashtagSerializer)
                              })
    end

    # POST /hashtags
    def create
      hashtag_data=hashtag_params
      hashtag_data[:user_id]=current_user.id
      @hashtag = Hashtag.new(hashtag_data)
      if @hashtag.save
        render_success_response({
                                    hashtag: single_serializer(@hashtag, HashtagSerializer)
                                }, I18n.t('common.created', model: 'Hashtag'))
      else
        render_unprocessable_entity_response(@hashtag)
      end
    end

    # PATCH/PUT /hashtags/1
    def update
      if @hashtag.update(hashtag_params)
        render_success_response({
                                    hashtag: single_serializer(@hashtag, HashtagSerializer)
                                }, I18n.t('common.updated', model: 'Hashtag'))
      else
        render_unprocessable_entity_response(@hashtag)
      end
    end

    # DELETE /hashtags/1
    def destroy
      @hashtag.destroy
      render_success_response({
                                  hashtag: single_serializer(@hashtag, HashtagSerializer)
                              }, I18n.t('common.deleted', model: 'Hashtag'))
    end


    # POST /hashtags/:hashtag_slug/follow
    def follow
      hashtag=Hashtag.find_or_create_by(:slug=>params[:hashtag_slug])
      hashtag_follower = HashtagFollower.find_by(:user_id => current_user.id, :hashtag_id => hashtag.id)
      unless hashtag_follower.present?
        @hashtag_follower = HashtagFollower.new(:user_id => current_user.id, :hashtag_id => hashtag.id)
        @hashtag_followers = HashtagFollower.where(:hashtag_id => hashtag.id).paginate(page: params[:page], per_page: PAGE_COUNT)
        if @hashtag_follower.save
          hashtag.create_activity key: 'hashtag.followed', owner: current_user

          render_success_response({
                                      hashtag_follower: single_serializer(@hashtag_follower, HashtagFollowerSerializer)
                                  }, I18n.t('common.followed', model: "##{hashtag.slug}"))
        else
          render_unprocessable_entity_response(@hashtag_follower)
        end
      else
        render_unprocessable_entity(I18n.t('common.already_following'))
      end
      end
    def unfollow
      hashtag=Hashtag.find_by(:slug=>params[:hashtag_slug])
      hashtag_follower = HashtagFollower.find_by(:user_id => current_user.id, :hashtag_id => hashtag.id)
      if hashtag_follower.present?
        hashtag.create_activity key: 'hashtag.unfollowed', owner: current_user
        HashtagFollower.delete(hashtag_follower.id)
        @hashtag_followers = HashtagFollower.where(:hashtag_id => hashtag.id).paginate(page: params[:page], per_page: PAGE_COUNT)

        render_success_response({
                                    hashtag_follower: single_serializer(@hashtag_follower, HashtagFollowerSerializer)
                                }, I18n.t('common.unfollowed', model: "##{hashtag.slug}"))

      else
        render_unprocessable_entity(I18n.t('common.not_following'))
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_hashtag
      @hashtag = Hashtag.find_by(:slug=>params[:slug])
      unless @hashtag.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Hashtag'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def hashtag_params
      # params.fetch(:hashtag, {})
      params.require(:hashtag).permit(:id, :content, :user_id, :privacy_id,:hashtag_attachments_attributes=>[:id,:media,:hashtag_id,:_destroy],:hashtag_hashtags_attributes=>[:id,:hashtag_id,:hashtag_slug,:hashtag_id,:_destroy])
    end

  end
end
