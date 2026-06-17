module Courses
  # When a user has completed every published lesson in a course, mark the
  # enrollment completed and grant the course's badge. Idempotent.
  class AwardBadgeIfComplete
    def initialize(course:, user:)
      @course = course
      @user = user
    end

    def call
      lesson_ids = @course.published_lessons.pluck(:id)
      return if lesson_ids.empty?

      completed = LessonCompletion.where(user_id: @user.id, lesson_id: lesson_ids).count
      return unless completed >= lesson_ids.size

      enrollment = @course.enrollments.find_or_create_by!(user: @user)
      unless enrollment.completed?
        enrollment.update!(status: :completed, completed_at: enrollment.completed_at || Time.current)
      end

      BadgeAward.find_or_create_by!(user: @user, badge: @course.badge) if @course.badge
    end
  end
end
