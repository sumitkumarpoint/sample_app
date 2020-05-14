class PostAttachment < ApplicationRecord
  belongs_to :post

  has_attached_file :media,
                    styles: Proc.new { |clip| (clip.instance.media_content_type.include?('image')? { midium: "300x300>"}: {}) }




  validates_attachment_content_type :media,
                                    :content_type => /(^image)|(^video)/,
                                    :message => 'file type is not allowed (only video/images are allowed)'

  validates_attachment_content_type :media,
                                    :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/,
                                    :message => 'file type is not allowed (only jpeg/png/gif images)',
                                    :if=> :is_image?
  validates_attachment_content_type :media,
                                    :content_type => /^video\/(3gp|mp4)$/,
                                    :message => 'file type is not allowed (only 3gp/mp4 videos)',
                                    :if=> :is_video?


  private
  def is_video?
    media.instance.media_content_type =~ %r(video)
  end
  def is_image?
    media.instance.media_content_type =~ %r(image)
  end

end
