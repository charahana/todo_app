class Task < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum status: {not_started: 0, in_progress:1, done: 2}
  enum priority: {low: 0, medium: 1, high: 2}

  validates :title, presence: true
  validates :body, presence: true
  
  scope :recent, -> { order(created_at: :desc) }
  scope :due_soon, -> { where(due_date: Time.current..3.days.from_now) }
end
