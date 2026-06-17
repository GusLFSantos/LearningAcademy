module Lessons
  # Safely accumulates a user's active time on a lesson. Each heartbeat is
  # clamped to a sane maximum so a tampered/backgrounded client can't inflate it.
  class RecordTime
    MAX_INCREMENT = 120 # seconds per call (heartbeats fire far more often)

    def initialize(lesson:, user:, seconds:)
      @lesson = lesson
      @user = user
      @seconds = seconds.to_i
    end

    def call
      increment = @seconds.clamp(0, MAX_INCREMENT)
      return if increment.zero?

      log = LessonTimeLog.find_or_create_by!(user: @user, lesson: @lesson)
      log.increment!(:seconds, increment) # atomic UPDATE … SET seconds = seconds + n
      log
    end
  end
end
