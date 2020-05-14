class ActivitiesSerializer < ActiveModel::Serializer
  attributes :id, :trackable_type, :trackable_id, :owner_type, :owner_id, :key, :parameters, :recipient_type, :recipient_id, :activity
  include ResourceRenderer
  def activity
    current_object=self.object
    {
        message: "#{current_object.key.split('.')[1]}",
        "#{current_object.key.split('.')[0]}": single_serializer(current_object.trackable_type.constantize.find_by(:id=>current_object.trackable_id), "#{current_object.trackable_type}Serializer".constantize)
    }
  end
end
