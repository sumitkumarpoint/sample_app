class AdvertisementSerializer < ActiveModel::Serializer
  attributes :id,:slug, :campaign_name, :objective, :budget_type, :budget_amount, :start_date, :end_date, :age_from, :age_to, :gender, :media_type,:media_medium ,:media_original, :primary_text, :website_url, :call_to_action, :user_id,:advertisement_locations,:advertisement_job_roles ,:advertisement_skills,:advertisement_likes,:advertisement_shares,:advertisement_comments
  def media_original
    self.object.media.url(:original)
    self.object.media.url(:original)
  end
  def media_medium
    self.object.media.url(:medium)
  end
  has_many :advertisement_job_roles
  has_many :advertisement_skills
  has_many :advertisement_locations
  has_many :advertisement_likes
  has_many :advertisement_shares
  has_many :advertisement_comments
end
