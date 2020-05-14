class UserSkillSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_profile_id
  # belongs_to :user_profile
end
