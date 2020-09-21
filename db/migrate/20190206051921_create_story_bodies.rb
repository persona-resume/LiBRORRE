class CreateStoryBodies < ActiveRecord::Migration[5.2]
  def change
    create_table :story_bodies do |t|
      t.integer :story_topic_id
      t.text :content
      t.integer :type

      t.timestamps
    end
  end
end
