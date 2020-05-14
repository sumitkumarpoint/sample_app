class CreateUserWorkExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :user_work_experiences do |t|
      t.string :title
      t.integer :employment_type
      t.string :company
      t.string :location
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :still_working_here
      t.text :description
      t.integer :user_profile_id

      t.timestamps
    end
  end
end
