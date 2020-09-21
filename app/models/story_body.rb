class StoryBody < ApplicationRecord
  belongs_to :story_topic

  validates :content, presence: true
  validates :text_type, presence: true
end
