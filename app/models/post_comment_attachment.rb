class PostCommentAttachment < ApplicationRecord
  belongs_to :post_comment
  has_attached_file :media, styles: {
      medium: '300x300>'
  }

  validates_attachment_content_type :media, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

end
