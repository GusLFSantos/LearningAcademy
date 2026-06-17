class LessonTimeLog < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  validates :user_id, uniqueness: { scope: :lesson_id }
  validates :seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
