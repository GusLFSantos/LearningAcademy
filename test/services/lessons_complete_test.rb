require "test_helper"

class LessonsCompleteTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "U", email: "complete@test.x")
  end

  test "auto-enrolls and marks the lesson complete" do
    course = create_course_with_lessons(count: 2)
    lesson = course.lessons.first

    Lessons::Complete.new(lesson: lesson, user: @user).call

    assert lesson.completed_by?(@user)
    assert course.enrolled?(@user)
  end

  test "is idempotent for the same lesson" do
    lesson = create_course_with_lessons(count: 1).lessons.first

    assert_difference -> { LessonCompletion.count }, 1 do
      2.times { Lessons::Complete.new(lesson: lesson, user: @user).call }
    end
  end

  test "completing the final lesson awards the course badge" do
    course = create_course_with_lessons(count: 1)
    lesson = course.lessons.first

    Lessons::Complete.new(lesson: lesson, user: @user).call

    assert course.badge.earned_by?(@user)
    assert course.enrollment_for(@user).completed?
  end
end
