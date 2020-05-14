module Api::V1
  class PostCommentsController < ApplicationController
    before_action :set_post_comment, only: [:show, :update, :destroy]
    before_action :authenticate_user!, except: [:index]
    # GET /posts/:post_slug/post_comments
    def index
      @post_comments = Post.includes(:post_comments).find_by(:slug => params[:post_slug]).post_comments.paginate(page: params[:page], per_page: PAGE_COUNT)

      render_success_response({
                                  post_comments: array_serializer.new(@post_comments, serializer: PostCommentSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@post_comments)
                              })
    end

    # GET /posts/:post_slug/post_comments/1
    def show
      # render json: @post_comment
      render_success_response({
                                  post_comment: single_serializer(@post_comment, PostCommentSerializer)
                              })
    end

    # POST /posts/:post_slug/post_comments
    def create
      post = Post.find_by(:slug => params[:post_slug])
      if post.present?
        post_comment_data         = post_comment_params
        post_comment_data[:user_id] = current_user.id
        post_comment_data[:post_id] = post.id
        @post_comment             = PostComment.new(post_comment_data)

        if @post_comment.save
          post.create_activity key: 'post.commented_on', owner: current_user
          render_success_response({
                                      post_comment: single_serializer(@post_comment, PostCommentSerializer)
                                  }, I18n.t('common.created', model: 'Comment'))
        else
          render_unprocessable_entity_response(@post_comment)
        end
      else
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Post'))
      end
    end

    # PATCH/PUT /posts/:post_slug/post_comments/1
    def update
      post = Post.find_by(:slug => params[:post_slug])
      if post.present?
      if @post_comment.user_id == current_user.id && @post_comment.update(post_comment_params)
        # post.create_activity key: 'post.edited_comment_on', owner: current_user
        render_success_response({
                                    post_comment: single_serializer(@post_comment, PostCommentSerializer)
                                }, I18n.t('common.updated', model: 'Comment'))
      else
        render_unprocessable_entity_response(@post_comment)
      end
      else
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Post'))
      end
    end

    # DELETE /posts/:post_slug/post_comments/1
    def destroy
      post = Post.find_by(:slug => params[:post_slug])
      if post.present?
        @activity = PublicActivity::Activity.find_by(key: 'post.commented_on',owner_id: current_user.id,trackable_id: post.id, trackable_type: "Post")
        @activity.destroy
      end
      @post_comment.destroy
      render_success_response({
                                  post_comment: single_serializer(@post_comment, PostCommentSerializer)
                              }, I18n.t('common.deleted', model: 'Comment'))
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post_comment
      @post_comment = PostComment.find_by(:id=>params[:id])
      unless @post_comment.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'Comment'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def post_comment_params
      params.require(:post_comment).permit(:id, :content,:post_comment_attachments_attributes=>[:id,:media,:post_comment_id,:_destroy])
    end
  end
end
