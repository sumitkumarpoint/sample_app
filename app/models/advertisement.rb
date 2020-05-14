class Advertisement < ApplicationRecord
  has_many :advertisement_likes
  has_many :advertisement_shares
  has_many :advertisement_comments
  has_many :advertisement_job_roles,dependent: :destroy
  has_many :advertisement_skills,dependent: :destroy
  has_many :advertisement_locations,dependent: :destroy
  accepts_nested_attributes_for :advertisement_skills, :allow_destroy => true
  accepts_nested_attributes_for :advertisement_job_roles, :allow_destroy => true
  accepts_nested_attributes_for :advertisement_locations, :allow_destroy => true
  has_attached_file :media, styles: {
      medium: '300x300>'
  }

  validates_attachment_content_type :media, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

  extend FriendlyId
  friendly_id :campaign_name, use: :slugged
  def normalize_friendly_id(string)
    super[0..150]
  end

end
