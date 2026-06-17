require "test_helper"

class CoursesAwardBadgeTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "U", email: "award@test.x")
    @course = create_course_with_lessons(count: 2)
  end

  test "does not award until every lesson is complete" do
    LessonCompletion.create!(user: @user, lesson: @course.lessons.first)

    assert_no_difference -> { BadgeAward.count } do
      Courses::AwardBadgeIfComplete.new(course: @course, user: @user).call
    end
    assert_not @course.badge.earned_by?(@user)
  end

  test "awards the badge and completes the enrollment when all lessons are done" do
    @course.lessons.each { |l| LessonCompletion.create!(user: @user, lesson: l) }

    assert_difference -> { BadgeAward.count }, 1 do
      Courses::AwardBadgeIfComplete.new(course: @course, user: @user).call
    end

    assert @course.badge.earned_by?(@user)
    enrollment = @course.enrollment_for(@user)
    assert enrollment.completed?
    assert enrollment.completed_at.present?
  end

  test "is idempotent — awards only once" do
    @course.lessons.each { |l| LessonCompletion.create!(user: @user, lesson: l) }
    Courses::AwardBadgeIfComplete.new(course: @course, user: @user).call

    assert_no_difference -> { BadgeAward.count } do
      Courses::AwardBadgeIfComplete.new(course: @course, user: @user).call
    end
  end
end
