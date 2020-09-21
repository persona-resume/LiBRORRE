class CreateArticleHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :article_histories do |t|
      t.integer :article_id
      t.integer :user_id
      t.string :title
      t.text :mean
      t.text :cause

      t.timestamps
    end
  end
end
