class UserAccomplishmentSerializer < ActiveModel::Serializer
  attributes :id, :category, :award_organization, :website, :location, :award, :date_received, :user_profile_id
end
