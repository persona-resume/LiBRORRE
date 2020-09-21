class CreateStoryComments < ActiveRecord::Migration[5.2]
  def change
    create_table :story_comments do |t|
      t.integer :story_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
