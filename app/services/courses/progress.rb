module Courses
  # Single source of truth for a user's progression through a course:
  # completion status, percentage, and time (estimated vs. actually spent).
  class Progress
    Result = Struct.new(
      :completed, :total, :percent, :status,
      :time_spent_seconds, :estimated_minutes,
      keyword_init: true
    )

    def initialize(course, user)
      @course = course
      @user = user
    end

    def self.call(course, user)
      new(course, user).call
    end

    def call
      total = lesson_ids.size
      completed = completed_count
      percent = total.zero? ? 0 : ((completed.to_f / total) * 100).round

      Result.new(
        completed: completed,
        total: total,
        percent: percent,
        status: status(completed, total),
        time_spent_seconds: time_spent_seconds,
        estimated_minutes: estimated_minutes
      )
    end

    private

    def lesson_ids
      @lesson_ids ||= @course.published_lessons.pluck(:id)
    end

    def completed_count
      return 0 if @user.nil? || lesson_ids.empty?
      LessonCompletion.where(user_id: @user.id, lesson_id: lesson_ids).count
    end

    def status(completed, total)
      return :not_started unless @user && @course.enrolled?(@user)
      return :completed if total.positive? && completed >= total
      :in_progress
    end

    def time_spent_seconds
      return 0 if @user.nil? || lesson_ids.empty?
      LessonTimeLog.where(user_id: @user.id, lesson_id: lesson_ids).sum(:seconds)
    end

    def estimated_minutes
      @course.published_lessons.sum(:estimated_minutes)
    end
  end
end
