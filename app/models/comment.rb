class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :body, presence: true
end
