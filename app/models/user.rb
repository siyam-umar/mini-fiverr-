class User < ApplicationRecord
  has_many :services
has_many :orders # for clients who place orders
has_many :purchases, through: :orders, source: :service

has_many :reviews
has_many :messages
has_many :conversations, foreign_key: :sender_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
