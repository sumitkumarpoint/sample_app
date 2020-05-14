class AdvertisementComment < ApplicationRecord
  belongs_to :advertisement
  has_many :advertisement_comment_attachments,dependent: :destroy
  accepts_nested_attributes_for :advertisement_comment_attachments, :allow_destroy => true
end
