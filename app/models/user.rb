class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :article_histories, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :story_comments, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :libraries, dependent: :destroy
  has_many :visiteds, dependent: :destroy

  validates :name, presence: true, length:{maximum: 20}
  validates :email, presence: true, length:{maximum: 50}
  validates :caption, length:{maximum: 140}

  attachment :image

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end

end
