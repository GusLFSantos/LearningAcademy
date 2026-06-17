class QuizzesController < ApplicationController
  before_action :set_lesson

  def show
    @quiz = @lesson.quiz
    if @quiz.nil?
      redirect_to course_lesson_path(@course, @lesson), alert: "This lesson has no quiz yet."
      return
    end
    @questions = @quiz.questions.includes(:answer_options)
  end

  # Authoring. Builds blank slots so authors can add a question / options
  # without any client-side cloning (blank rows are rejected on save).
  def edit
    @quiz = find_or_build_quiz
    add_blank_slots
  end

  def update
    @quiz = find_or_build_quiz
    if @quiz.update(quiz_params)
      redirect_to course_lesson_path(@course, @lesson), notice: "Quiz saved."
    else
      add_blank_slots
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_lesson
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.find(params[:lesson_id])
  end

  def find_or_build_quiz
    @lesson.quiz || @lesson.build_quiz(pass_percentage: 70, title: "#{@lesson.title} quiz")
  end

  def add_blank_slots
    @quiz.questions.each { |q| q.answer_options.build } # one extra option slot per question
    blank = @quiz.questions.build                        # one extra blank question…
    3.times { blank.answer_options.build }               # …with three option slots
  end

  # TODO: authorize
  def quiz_params
    params.require(:quiz).permit(
      :title, :pass_percentage,
      questions_attributes: [
        :id, :prompt, :position, :_destroy,
        answer_options_attributes: [:id, :body, :correct, :position, :_destroy]
      ]
    )
  end
end
