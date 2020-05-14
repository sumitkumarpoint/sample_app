class Hashtag < ApplicationRecord
  has_and_belongs_to_many :post_hashtags
  has_many :hashtag_followers
end
