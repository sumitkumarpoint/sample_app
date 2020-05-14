class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :slug, :phone,:profile_viewers
  has_one :user_profile
  has_many :profile_viewers
  has_many :posts
  has_many :post_viewers,through: :posts
end
