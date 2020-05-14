class PostShare < ApplicationRecord
  belongs_to :post,:optional => true
end
