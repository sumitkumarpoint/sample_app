class CreateCompanyPages < ActiveRecord::Migration[5.2]
  def change
    create_table :company_pages do |t|
      t.attachment :profile_image
      t.attachment :cover_image
      t.string :page_identity
      t.string :tagline
      t.string :public_url
      t.string :website
      t.string :industry
      t.string :company_size
      t.string :street
      t.string :address
      t.string :zip_code
      t.string :year_of_establishment
      t.string :company_type
      t.integer :user_id

      t.timestamps
    end
    add_index :company_pages, :public_url, unique: true
  end
end
