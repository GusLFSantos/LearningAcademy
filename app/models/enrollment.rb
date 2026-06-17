class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  enum :status, { in_progress: 0, completed: 1 }

  validates :user_id, uniqueness: { scope: :course_id }

  before_validation :set_started_at, on: :create

  def duration_seconds
    return nil unless started_at && completed_at
    (completed_at - started_at).round
  end

  private

  def set_started_at
    self.started_at ||= Time.current
  end
end
