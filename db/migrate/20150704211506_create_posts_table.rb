class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :body
      t.timestamp null: false
      t.integer :user_id
    end
    add_index :posts, :user_id
  end
end
