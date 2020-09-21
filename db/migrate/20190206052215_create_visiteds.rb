class CreateVisiteds < ActiveRecord::Migration[5.2]
  def change
    create_table :visiteds do |t|
      t.integer :user_id
      t.integer :story_id

      t.timestamps
    end
  end
end
