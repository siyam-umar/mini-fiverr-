class Review < ApplicationRecord
   include ActionView::RecordIdentifier 
  belongs_to :user
  belongs_to :service

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true

  # Turbo Streams broadcasts
  after_create_commit  -> { broadcast_prepend_later_to [service, :reviews], target: dom_id(service, :reviews) }
  after_update_commit  -> { broadcast_replace_later_to [service, :reviews] }
  after_destroy_commit -> { broadcast_remove_to [service, :reviews] }

  after_commit :broadcast_rating_summary, on: [:create, :update, :destroy]

  private

  def broadcast_rating_summary
    broadcast_replace_later_to [service, :reviews],
      target: dom_id(service, :rating_summary),
      partial: "reviews/rating_summary",
      locals: { service: service }
  end
end


