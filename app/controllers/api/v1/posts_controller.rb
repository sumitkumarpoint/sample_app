module Api::V1
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]
    before_action :authenticate_user!
    # GET /posts
    def index

      @posts = Post.includes(:post_comments, :post_shares, :post_likes).paginate(page: params[:page], per_page: PAGE_COUNT)

      render_success_response({
                                  posts: array_serializer.new(@posts, serializer: PostSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@posts)
                              })

    end

    # GET /posts/1
    def show
      post_viewers= @post.post_viewers.find_or_create_by(:viewer_id=>current_user.id) if current_user.present? && current_user.id != @post.user_id
      render_success_response({
                                  post: single_serializer(@post, PostSerializer)
                              })
    end

    # POST /posts
    def create
      post_data=post_params
      post_data[:user_id]=current_user.id
      @post = Post.new(post_data)
      if @post.save
        @post.create_activity key: 'post.created', owner: current_user
        render_success_response({
                                    post: single_serializer(@post, PostSerializer)
                                }, I18n.t('common.created', model: 'Post'))
      else
        render_unprocessable_entity_response(@post)
      end
    end

    # PATCH/PUT /posts/1
    def update
      post_hashtags_ids=@post.post_hashtags.ids
      if @post.update(post_params)
        PostHashtag.delete(post_hashtags_ids)
        @post.create_activity key: 'post.updated', owner: current_user
        render_success_response({
                                    post: single_serializer(@post, PostSerializer)
                                }, I18n.t('common.updated', model: 'Post'))
      else
        render_unprocessable_entity_response(@post)
      end
    end

    # DELETE /posts/1
    def destroy
      @post.destroy
      @activity = PublicActivity::Activity.where(trackable_id: @post.id, trackable_type: "Post")
      @activity.destroy_all
      render_success_response({
                                  post: single_serializer(@post, PostSerializer)
                              }, I18n.t('common.deleted', model: 'Post'))
    end

    # POST /posts/:post_slug/like_dislike
    def like_dislike
      post=Post.find_by(:slug=>params[:post_slug])
      if post.present?
        @post_like  = PostLike.find_by(:user_id => current_user.id, :post_id => post.id)
        @post_likes = PostLike.where(:post_id => post.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      if @post_like.present?
        if PostLike.destroy(@post_like.id)
          # post.create_activity key: 'post.liked', owner: current_user
          @activity = PublicActivity::Activity.find_by(key: 'post.liked',owner_id: current_user.id,trackable_id: post.id, trackable_type: "Post")
          @activity.destroy
          render_success_response({
                                      post_likes: array_serializer.new(@post_likes, serializer: PostLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@post_likes)
                                  })
        else
          render_unprocessable_entity_response(@post_like)
        end
      else
        @post_like = PostLike.new(:user_id => current_user.id, :post_id => post.id)
        if @post_like.save
          post.create_activity key: 'post.liked', owner: current_user
          render_success_response({
                                      post_likes: array_serializer.new(@post_likes, serializer: PostLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@post_likes)
                                  })
        else
          render_unprocessable_entity_response(@post_like)
        end
      end
    end

    # POST /posts/:post_slug/share
    def share
      post=Post.find_by(:slug=>params[:post_slug])
      if post.present?
        post.create_activity key: 'post.shared', owner: current_user
        @post_share  = PostShare.find_by(:user_id => current_user.id, :post_id => post.id)
        @post_shares = PostShare.where(:post_id => post.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      # unless @post_share.present?
        @post_share = PostShare.new(:user_id => current_user.id, :post_id => post.id)
        if @post_share.save
          render_success_response({
                                      post_shares: array_serializer.new(@post_shares, serializer: PostShareSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@post_shares)
                                  })
        else
          render_unprocessable_entity_response(@post_share)
        end
      # else
      #   render json: @post_shares
      # end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by(:slug=>params[:slug])
      unless @post.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Post'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      # params.fetch(:post, {})
      params.require(:post).permit(:id, :content, :user_id, :privacy_id,:post_attachments_attributes=>[:id,:media,:post_id,:_destroy],:post_hashtags_attributes=>[:id,:hashtag_id,:hashtag_slug,:post_id,:_destroy])
    end

  end
end
