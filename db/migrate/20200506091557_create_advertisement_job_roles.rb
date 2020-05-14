class CreateAdvertisementJobRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisement_job_roles do |t|
      t.string :name
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
