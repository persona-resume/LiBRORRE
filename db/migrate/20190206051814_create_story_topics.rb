class CreateStoryTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :story_topics do |t|
      t.integer :story_id
      t.string :title

      t.timestamps
    end
  end
end
