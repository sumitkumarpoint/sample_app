class PostSerializer < ActiveModel::Serializer
  attributes :id,:slug, :content, :user_id, :privacy_id, :post_likes, :post_comments, :post_shares,:post_attachments,:post_hashtags

  has_many :post_likes
  has_many :post_comments
  has_many :post_shares
  has_many :post_hashtags
  def post_attachments
      self.object.post_attachments.map do |attachment|
        if attachment.media_content_type=~ %r(image)
        {
            media_content_type: attachment.media_content_type,
            media_original: attachment.media.url(:original),
            media_medium: attachment.media.url(:medium)
        }
        else
          {
              media_content_type: attachment.media_content_type,
              media_medium: attachment.media.url(:medium)
          }
        end
      end
  end

end
