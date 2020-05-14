class PostLike < ApplicationRecord
  belongs_to :post,:optional => true
end
