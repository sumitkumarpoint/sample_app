module Api::V1
  class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :update, :destroy]
    before_action :authenticate_user!
    # GET /groups
    def index

      @groups = Group.paginate(page: params[:page], per_page: PAGE_COUNT)

      render_success_response({
                                  groups: array_serializer.new(@groups, serializer: GroupSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@groups)
                              })

    end

    # GET /groups/slug
    def show
      group_viewers= @group.group_viewers.find_or_create_by(:viewer_id=>current_user.id) if current_user.present? && current_user.id != @group.user_id
      render_success_response({
                                  group: single_serializer(@group, GroupSerializer)
                              })
    end

    # POST /groups
    def create
      group_data=group_params
      group_data[:user_id]=current_user.id
      @group = Group.new(group_data)
      if @group.save
        @group.create_activity key: 'group.created', owner: current_user
        render_success_response({
                                    group: single_serializer(@group, GroupSerializer)
                                }, I18n.t('common.created', model: 'Group'))
      else
        render_unprocessable_entity_response(@group)
      end
    end

    # PATCH/PUT /groups/slug
    def update
      # group_hashtags_ids=@group.group_hashtags.ids
      if @group.update(group_params)
        # PageHashtag.delete(group_hashtags_ids)
        # @group.create_activity key: 'group.updated', owner: current_user
        render_success_response({
                                    group: single_serializer(@group, GroupSerializer)
                                }, I18n.t('common.updated', model: 'Group'))
      else
        render_unprocessable_entity_response(@group)
      end
    end

    # DELETE /groups/slug
    def destroy
      @group.destroy
      @activity = PublicActivity::Activity.where(trackable_id: @group.id, trackable_type: "Group")
      @activity.destroy_all
      render_success_response({
                                  group: single_serializer(@group, GroupSerializer)
                              }, I18n.t('common.deleted', model: 'Group'))
    end

    # POST /groups/:group_slug/like_dislike
    def like_dislike
      group=Group.find_by(:slug=>params[:group_slug])
      if group.present?
        @group_like  = PageLike.find_by(:user_id => current_user.id, :group_id => group.id)
        @group_likes = PageLike.where(:group_id => group.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      if @group_like.present?
        if PageLike.destroy(@group_like.id)
          # group.create_activity key: 'group.liked', owner: current_user
          @activity = PublicActivity::Activity.find_by(key: 'group.liked',owner_id: current_user.id,trackable_id: group.id, trackable_type: "Group")
          @activity.destroy
          render_success_response({
                                      group_likes: array_serializer.new(@group_likes, serializer: GroupLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@group_likes)
                                  })
        else
          render_unprocessable_entity_response(@group_like)
        end
      else
        @group_like = PageLike.new(:user_id => current_user.id, :group_id => group.id)
        if @group_like.save
          group.create_activity key: 'group.liked', owner: current_user
          render_success_response({
                                      group_likes: array_serializer.new(@group_likes, serializer: GroupLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@group_likes)
                                  })
        else
          render_unprocessable_entity_response(@group_like)
        end
      end
    end

    # POST /groups/:group_slug/share
    def share
      group=Group.find_by(:slug=>params[:group_slug])
      if group.present?
        group.create_activity key: 'group.shared', owner: current_user
        @group_share  = PageShare.find_by(:user_id => current_user.id, :group_id => group.id)
        @group_shares = PageShare.where(:group_id => group.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      # unless @group_share.present?
        @group_share = PageShare.new(:user_id => current_user.id, :group_id => group.id)
        if @group_share.save
          render_success_response({
                                      group_shares: array_serializer.new(@group_shares, serializer: GroupShareSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@group_shares)
                                  })
        else
          render_unprocessable_entity_response(@group_share)
        end
      # else
      #   render json: @group_shares
      # end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find_by(:slug=>params[:slug])
      unless @group.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Group'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      # params.fetch(:group, {})
      params.require(:group).permit(:id, :slug, :profile_image, :cover_image, :name, :description, :location, :is_private, :allow_member_to_invite, :require_to_be_review, :user_id)
    end

  end
end
