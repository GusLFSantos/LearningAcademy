class User < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :lesson_completions, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy
  has_many :lesson_time_logs, dependent: :destroy
  has_many :badge_awards, dependent: :destroy
  has_many :badges, through: :badge_awards

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Total active learning time across every lesson, in seconds.
  def total_time_spent_seconds
    lesson_time_logs.sum(:seconds)
  end
end
