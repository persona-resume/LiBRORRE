class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :title
      t.integer :article_id
      t.integer :user_id

      t.timestamps
    end

    add_index :stories, :title
  end
end
