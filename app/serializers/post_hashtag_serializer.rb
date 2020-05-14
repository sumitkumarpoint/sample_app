class PostHashtagSerializer < ActiveModel::Serializer
  attributes :id, :hashtag_id, :hashtag_slug, :post_id
end
