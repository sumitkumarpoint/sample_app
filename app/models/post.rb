class Post < ApplicationRecord
  has_many :post_likes
  has_many :post_comments
  has_many :post_shares
  has_many :post_attachments,dependent: :destroy
  has_many :post_viewers
  belongs_to :user
  has_many :post_hashtags,dependent: :destroy
  # has_many :hashtags ,through: :post_hashtags
  accepts_nested_attributes_for :post_hashtags,allow_destroy: true
  accepts_nested_attributes_for :post_attachments, :allow_destroy => true

  extend FriendlyId
  friendly_id :content, use: :slugged
  def normalize_friendly_id(string)
    super[0..150]
  end

end
