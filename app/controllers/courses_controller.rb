class CoursesController < ApplicationController
  before_action :set_course, only: [ :show, :edit, :update, :destroy ]

  def index
    @courses = Course.published.ordered
    @drafts = Course.where(published: false).ordered
  end

  def show
    @lessons = @course.lessons.ordered
    @progress = @course.progress_for(current_user)
    @enrollment = @course.enrollment_for(current_user)
  end

  def new
    @course = Course.new
    @course.build_badge
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to @course, notice: "Course created."
    else
      @course.build_badge if @course.badge.nil?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @course.build_badge if @course.badge.nil?
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Course updated."
    else
      @course.build_badge if @course.badge.nil?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: "Course deleted.", status: :see_other
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  # TODO: authorize — restrict authoring to admins once auth/roles are added.
  def course_params
    params.require(:course).permit(
      :title, :slug, :summary, :description, :position, :published,
      badge_attributes: [ :id, :name, :icon, :description, :_destroy ]
    )
  end
end
