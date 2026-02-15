class Task < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum status: {not_started: 0, in_progress:1, done: 2}
  enum priority: {low: 0, medium: 1, high: 2}

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 1000 }
  validate :due_date_cannot_be_in_the_past
  
  scope :recent, -> { order(created_at: :desc) }
  scope :due_soon, -> { where(due_date: Time.current..3.days.from_now) }

  def due_date_cannot_be_in_the_past
    return if due_date.blank?

    if due_date < Time.current
      errors.add(:due_date, "は現在より未来の日時を設定してください")
    end
  end
end
