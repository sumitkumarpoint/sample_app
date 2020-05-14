class UserWebsiteUrlSerializer < ActiveModel::Serializer
  attributes :id, :provider, :url, :user_profile_id
end
