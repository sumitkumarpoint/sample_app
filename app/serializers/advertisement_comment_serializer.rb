class AdvertisementCommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :advertisement_id,:advertisement_comment_attachments
  def advertisement_comment_attachments
    self.object.advertisement_comment_attachments.map do |comment|
      {
          media_content_type: comment.media_content_type,
          media_original: comment.media.url(:original),
          media_medium: comment.media.url(:medium)
      }
    end
  end
end
