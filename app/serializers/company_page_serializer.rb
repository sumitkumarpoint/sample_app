class CompanyPageSerializer < ActiveModel::Serializer
  attributes :id, :profile_image, :cover_image, :page_identity, :tagline, :public_url, :website, :industry, :company_size, :street, :address, :zip_code, :year_of_establishment, :company_type, :user_id
end
