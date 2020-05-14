class PostCommentSerializer < ActiveModel::Serializer
  attributes :id,:content,:post_id,:user_id,:post_comment_attachments
  def post_comment_attachments
    self.object.post_comment_attachments.map do |comment|
      {
          media_content_type: comment.media_content_type,
          media_original: comment.media.url(:original),
          media_medium: comment.media.url(:medium)
      }
    end
  end
end
