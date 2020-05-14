class PostHashtag < ApplicationRecord
  has_and_belongs_to_many :hashtags
  belongs_to :post
  before_commit :update_hastag_id
  def update_hastag_id
    self.hashtag_id = Hashtag.find_or_create_by(:slug=> self.hashtag_slug).id
    self.save
  end

end
