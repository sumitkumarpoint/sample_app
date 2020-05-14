class UserProfile < ApplicationRecord
  belongs_to :user,optional: true
  has_many :user_work_experiences
  has_many :user_educations
  has_many :user_accomplishments
  has_many :user_skills,dependent:  :destroy
  has_many :user_website_urls
  accepts_nested_attributes_for :user_skills,allow_destroy: true
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
