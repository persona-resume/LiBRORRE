class StoryComment < ApplicationRecord
  belongs_to :user
  belongs_to :story

  validates :comment, presence: true

  def self.search(search)
    if search
      where(['comment LIKE ?', "%#{search}%"])
    else
      all
    end
  end

end
