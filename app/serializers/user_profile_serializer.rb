class UserProfileSerializer < ActiveModel::Serializer
  attributes :id,:first_name,:last_name,:profile_image_thumb,:profile_image_original,:birth_date,:user_work_experiences,:user_educations,:user_accomplishments,:user_skills,:user_website_urls,:cover_image,:location,:website,:current_position,:industry,:serving_notice_period,:last_working_date,:language
  # belongs_to :user
  has_many :user_work_experiences
  has_many :user_educations
  has_many :user_accomplishments
  has_many :user_skills
  has_many :user_website_urls
  def profile_image_original
    self.object.profile_image.url(:original)
  end
  def profile_image_thumb
    self.object.profile_image.url(:thumb)
  end
end
