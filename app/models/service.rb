class Service < ApplicationRecord
  belongs_to :user

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
end

