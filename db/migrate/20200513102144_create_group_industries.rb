class CreateGroupIndustries < ActiveRecord::Migration[5.2]
  def change
    create_table :group_industries do |t|
      t.string :industry
      t.integer :group_id

      t.timestamps
    end
  end
end
