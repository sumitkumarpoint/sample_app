class HashtagSerializer < ActiveModel::Serializer
  attributes :id, :slug
  has_many :hashtag_followers
end
