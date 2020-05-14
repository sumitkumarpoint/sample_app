class CompanyPage < ApplicationRecord
  validates_presence_of :page_identity, :message => "Please enter page identity"
  has_attached_file :profile_image, styles: {
      thumb: '100x100>',
      square: '200x200#'
  }

  validates_attachment_content_type :profile_image, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'
  has_attached_file :cover_image, styles: {
      thumb: '100x100>',
      square: '200x200#'
  }

  validates_attachment_content_type :cover_image, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

end
