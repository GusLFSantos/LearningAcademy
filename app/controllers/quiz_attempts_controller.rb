class QuizAttemptsController < ApplicationController
  before_action :set_lesson_and_quiz

  def create
    result = Quizzes::Grade.new(
      quiz: @quiz,
      user: current_user,
      answers: params[:answers],
      started_at: parse_time(params[:started_at])
    ).call

    Lessons::Complete.new(lesson: @lesson, user: current_user).call if result.passed

    redirect_to course_lesson_quiz_attempt_path(@course, @lesson, result.attempt)
  end

  def show
    @attempt = @quiz.quiz_attempts.where(user: current_user).find(params[:id])
    @questions = @quiz.questions.includes(:answer_options)
    @chosen_by_question = @attempt.attempt_answers.index_by(&:question_id)
    @progress = @course.progress_for(current_user)
  end

  private

  def set_lesson_and_quiz
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.find(params[:lesson_id])
    @quiz = @lesson.quiz
  end

  def parse_time(value)
    Time.zone.parse(value.to_s)
  rescue ArgumentError, TypeError
    nil
  end
end
