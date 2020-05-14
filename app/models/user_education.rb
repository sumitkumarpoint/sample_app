class UserEducation < ApplicationRecord
  belongs_to :user_profile
  validates_presence_of :university, :message => "Please fill university"
end
