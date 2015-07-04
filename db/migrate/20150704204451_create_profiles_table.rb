class CreateProfilesTable < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :city
      t.string :description
      t.integer :user_id
    end
    add_index :profiles, :user_id
  end
end
