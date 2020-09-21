class RenameTypeColumnToTextTypeInStoryBody < ActiveRecord::Migration[5.2]
  def change
    rename_column :story_bodies, :type, :text_type
  end
end
