class AddSlugToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slug, :string
    add_column :posts, :slug, :string
    add_index :users, :slug, unique: true
    add_index :posts, :slug, unique: true
  end
end
