# app/models/submission.rb
class Submission < ApplicationRecord
  belongs_to :order
  has_one_attached :file

  validates :file, presence: true
end

