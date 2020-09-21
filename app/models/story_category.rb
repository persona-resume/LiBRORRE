class StoryCategory < ApplicationRecord
  belongs_to :story
  belongs_to :category

  validates :story_id, presence: true
  validates :category_id, presence: true
end
