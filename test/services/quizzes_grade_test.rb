require "test_helper"

class QuizzesGradeTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "U", email: "grade@test.x")
    @quiz = create_course_with_lessons(count: 1).lessons.first.quiz
  end

  test "all-correct answers pass with a score of 100" do
    result = Quizzes::Grade.new(quiz: @quiz, user: @user, answers: correct_answers_for(@quiz)).call

    assert result.passed
    assert_equal 100, result.score
    assert result.attempt.persisted?
    assert_equal @quiz.questions.count, result.attempt.attempt_answers.count
  end

  test "wrong answers fail with a score of 0" do
    wrong = @quiz.questions.each_with_object({}) do |q, h|
      h[q.id.to_s] = q.answer_options.find_by(correct: false).id.to_s
    end

    result = Quizzes::Grade.new(quiz: @quiz, user: @user, answers: wrong).call

    assert_not result.passed
    assert_equal 0, result.score
  end

  test "records the attempt duration from started_at" do
    result = Quizzes::Grade.new(
      quiz: @quiz, user: @user,
      answers: correct_answers_for(@quiz), started_at: 30.seconds.ago
    ).call

    assert_operator result.attempt.duration_seconds, :>=, 29
  end

  test "missing answers count as incorrect" do
    result = Quizzes::Grade.new(quiz: @quiz, user: @user, answers: {}).call

    assert_not result.passed
    assert_equal 0, result.score
  end
end
