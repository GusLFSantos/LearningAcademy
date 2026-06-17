require "test_helper"

class LessonsRecordTimeTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "U", email: "time@test.x")
    @lesson = create_course_with_lessons(count: 1).lessons.first
  end

  test "accumulates seconds across calls" do
    Lessons::RecordTime.new(lesson: @lesson, user: @user, seconds: 30).call
    Lessons::RecordTime.new(lesson: @lesson, user: @user, seconds: 20).call

    assert_equal 50, LessonTimeLog.find_by(user: @user, lesson: @lesson).seconds
  end

  test "clamps a single increment to the maximum" do
    Lessons::RecordTime.new(lesson: @lesson, user: @user, seconds: 10_000).call

    assert_equal Lessons::RecordTime::MAX_INCREMENT,
                 LessonTimeLog.find_by(user: @user, lesson: @lesson).seconds
  end

  test "ignores non-positive values" do
    Lessons::RecordTime.new(lesson: @lesson, user: @user, seconds: 0).call
    Lessons::RecordTime.new(lesson: @lesson, user: @user, seconds: -5).call

    assert_nil LessonTimeLog.find_by(user: @user, lesson: @lesson)
  end
end
