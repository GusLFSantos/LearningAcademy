module Lessons
  # Marks a lesson complete for a user (idempotent), ensuring they're enrolled,
  # then checks whether the whole course is now finished and awards the badge.
  class Complete
    def initialize(lesson:, user:)
      @lesson = lesson
      @user = user
    end

    def call
      @lesson.course.enrollments.find_or_create_by!(user: @user)
      completion = LessonCompletion.find_or_create_by!(user: @user, lesson: @lesson)
      ::Courses::AwardBadgeIfComplete.new(course: @lesson.course, user: @user).call
      completion
    end
  end
end
