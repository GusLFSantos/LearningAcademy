ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module TestData
  # Builds a published course with `count` lessons, each with a single-question
  # quiz (one correct option) and, optionally, a completion badge.
  def create_course_with_lessons(count: 2, with_badge: true, pass_percentage: 70)
    course = Course.create!(title: "Course #{SecureRandom.hex(4)}", published: true)
    Badge.create!(course: course, name: "Badge #{SecureRandom.hex(2)}", icon: "🏅") if with_badge

    count.times do |i|
      lesson = course.lessons.create!(
        title: "Lesson #{i + 1}", body: "Body #{i + 1}", position: i + 1, estimated_minutes: 5
      )
      quiz = lesson.create_quiz!(title: "Quiz #{i + 1}", pass_percentage: pass_percentage)
      question = quiz.questions.create!(prompt: "Question #{i + 1}?", position: 1)
      question.answer_options.create!(body: "Correct", correct: true, position: 1)
      question.answer_options.create!(body: "Incorrect", correct: false, position: 2)
    end

    course
  end

  # { "<question_id>" => "<correct_option_id>" } for every question in the quiz.
  def correct_answers_for(quiz)
    quiz.questions.each_with_object({}) do |question, hash|
      hash[question.id.to_s] = question.correct_option.id.to_s
    end
  end
end

module ActiveSupport
  class TestCase
    # Single Postgres in dev/CI — keep tests serial to avoid per-worker databases.
    parallelize(workers: 1)

    fixtures :all

    include TestData
  end
end
