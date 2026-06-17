module Quizzes
  # Grades a submitted quiz: records the attempt and each chosen answer, then
  # computes a percentage score and pass/fail against the quiz's threshold.
  class Grade
    Result = Struct.new(:attempt, :passed, :score, keyword_init: true)

    # answers: { "<question_id>" => "<answer_option_id>", ... }
    def initialize(quiz:, user:, answers:, started_at: nil)
      @quiz = quiz
      @user = user
      @answers = answers || {}
      @started_at = started_at
    end

    def call
      questions = @quiz.questions.includes(:answer_options).to_a
      correct = 0
      attempt = nil

      ActiveRecord::Base.transaction do
        attempt = QuizAttempt.create!(
          user: @user, quiz: @quiz,
          started_at: @started_at || Time.current,
          completed_at: Time.current,
          score: 0, passed: false
        )

        questions.each do |question|
          option = chosen_option(question)
          next unless option

          attempt.attempt_answers.create!(question: question, answer_option: option)
          correct += 1 if option.correct?
        end

        score = questions.empty? ? 0 : ((correct.to_f / questions.size) * 100).round
        attempt.update!(score: score, passed: score >= @quiz.pass_percentage)
      end

      Result.new(attempt: attempt, passed: attempt.passed, score: attempt.score)
    end

    private

    def chosen_option(question)
      chosen_id = @answers[question.id.to_s] || @answers[question.id]
      return nil if chosen_id.blank?
      question.answer_options.detect { |o| o.id.to_s == chosen_id.to_s }
    end
  end
end
