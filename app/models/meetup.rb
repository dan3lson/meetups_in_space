class Meetup < ActiveRecord::Base
  has_many :reservations
  has_many :users, through: :users
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
  validates :description, presence: true
end
