class EnrollmentsController < ApplicationController
  before_action :set_course

  def create
    @course.enrollments.find_or_create_by!(user: current_user)
    redirect_to @course, notice: "You're enrolled in #{@course.title}."
  end

  def destroy
    @course.enrollments.where(user: current_user).destroy_all
    redirect_to @course, notice: "You've left #{@course.title}."
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end
