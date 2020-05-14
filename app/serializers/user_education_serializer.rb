class UserEducationSerializer < ActiveModel::Serializer
  attributes :id, :university, :website_url, :location, :degree, :starting_from, :ending_in, :details, :user_profile_id
  # belongs_to :user_profile
end
