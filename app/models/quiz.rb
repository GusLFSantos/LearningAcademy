class Quiz < ApplicationRecord
  belongs_to :lesson
  has_many :questions, -> { order(:position) }, dependent: :destroy
  has_many :answer_options, through: :questions
  has_many :quiz_attempts, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true,
    reject_if: ->(attrs) { attrs[:prompt].blank? }

  validates :pass_percentage, numericality: { only_integer: true, in: 0..100 }

  delegate :course, to: :lesson

  def best_attempt_for(user)
    return nil unless user
    quiz_attempts.where(user_id: user.id).order(score: :desc).first
  end

  def passed_by?(user)
    return false unless user
    quiz_attempts.exists?(user_id: user.id, passed: true)
  end
end
