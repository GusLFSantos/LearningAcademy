class AttemptAnswer < ApplicationRecord
  belongs_to :quiz_attempt
  belongs_to :question
  belongs_to :answer_option

  def correct?
    answer_option&.correct?
  end
end
