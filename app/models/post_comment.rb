class PostComment < ApplicationRecord
  belongs_to :post,:optional => true
  has_many :post_comment_attachments,dependent: :destroy
  accepts_nested_attributes_for :post_comment_attachments, :allow_destroy => true
end
