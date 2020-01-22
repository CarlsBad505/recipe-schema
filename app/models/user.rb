class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :recipes, through: :favorites
  
  validates :name, :email, presence: true
end
