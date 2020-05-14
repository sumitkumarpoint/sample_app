class GroupSerializer < ActiveModel::Serializer
  attributes :id, :slug, :profile_image, :cover_image, :name, :description, :location, :is_private, :allow_member_to_invite, :require_to_be_review, :user_id
  def profile_image
    {
       original: self.object.profile_image.url(:original),
       thumb: self.object.profile_image.url(:thumb)
    }
  end
  def cover_image
    {
        original: self.object.cover_image.url(:original),
        thumb: self.object.cover_image.url(:thumb)
    }
  end
end

