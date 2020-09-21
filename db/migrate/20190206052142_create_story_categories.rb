class CreateStoryCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :story_categories do |t|
      t.integer :story_id
      t.integer :category_id

      t.timestamps
    end
  end
end
