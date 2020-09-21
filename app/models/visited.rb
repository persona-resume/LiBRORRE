class Visited < ApplicationRecord
  belongs_to :story
  belongs_to :user
end
