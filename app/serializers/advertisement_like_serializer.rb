class AdvertisementLikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :advertisement_id
end
