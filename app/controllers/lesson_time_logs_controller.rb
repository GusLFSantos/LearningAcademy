# Receives lightweight heartbeats from the time_tracker Stimulus controller to
# accrue active reading time. Responds 204 — there's nothing to render.
class LessonTimeLogsController < ApplicationController
  def create
    course = Course.find(params[:course_id])
    lesson = course.lessons.find(params[:lesson_id])
    Lessons::RecordTime.new(lesson: lesson, user: current_user, seconds: params[:seconds]).call
    head :no_content
  end
end
