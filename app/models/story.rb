class Story < ApplicationRecord
  has_many :libraries

  has_many :story_categories, dependent: :destroy
  has_many :categories, through: :story_categories
  has_many :story_topics, dependent: :destroy
  has_many :story_comments, dependent: :destroy
  has_many :visiteds, dependent: :destroy

  accepts_nested_attributes_for :story_topics, allow_destroy: true

  belongs_to :user
  belongs_to :article

  validates :title, presence: true, length:{maximum: 50}

  def self.search(search)
    if search
      where(['title LIKE ?', "%#{search}%"])
    else
      all
    end
  end

  def save_story_categories(tags)
    current_tags = self.categories.pluck(:name) unless self.categories.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    # Destroy old taggings:
    old_tags.each do |old_name|
      self.categories.delete Category.find_by(name:old_name)
    end

    # Create new taggings:
    new_tags.each do |new_name|
      article_category = Category.find_or_create_by(name:new_name)
      self.categories << article_category
    end
  end

  def added_to_library?(user)
    libraries.where(user_id: user.id).exists?
  end

end
