class LessonCompletion < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  validates :user_id, uniqueness: { scope: :lesson_id }

  before_validation :set_completed_at, on: :create

  private

  def set_completed_at
    self.completed_at ||= Time.current
  end
end
