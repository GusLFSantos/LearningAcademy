class LessonsController < ApplicationController
  before_action :set_course
  before_action :set_lesson, only: [ :show, :edit, :update, :destroy ]

  def show
    @quiz = @lesson.quiz
    @completed = @lesson.completed_by?(current_user)
  end

  def new
    @lesson = @course.lessons.build(
      position: (@course.lessons.maximum(:position) || 0) + 1,
      estimated_minutes: 5
    )
  end

  def create
    @lesson = @course.lessons.build(lesson_params)
    if @lesson.save
      redirect_to course_lesson_path(@course, @lesson), notice: "Lesson created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to course_lesson_path(@course, @lesson), notice: "Lesson updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson.destroy
    redirect_to course_path(@course), notice: "Lesson deleted.", status: :see_other
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_lesson
    @lesson = @course.lessons.find(params[:id])
  end

  # TODO: authorize
  def lesson_params
    params.require(:lesson).permit(:title, :slug, :body, :position, :estimated_minutes, :published)
  end
end
