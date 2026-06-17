class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  has_many :attempt_answers, dependent: :destroy

  scope :passed, -> { where(passed: true) }

  def duration_seconds
    return nil unless started_at && completed_at
    (completed_at - started_at).round
  end
end
