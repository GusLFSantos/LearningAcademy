class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answer_options, -> { order(:position) }, dependent: :destroy
  has_many :attempt_answers, dependent: :destroy

  accepts_nested_attributes_for :answer_options, allow_destroy: true,
    reject_if: ->(attrs) { attrs[:body].blank? }

  validates :prompt, presence: true

  # MVP quizzes are single-correct multiple choice.
  def correct_option
    answer_options.detect(&:correct?)
  end

  def correct_option_id
    correct_option&.id
  end
end
