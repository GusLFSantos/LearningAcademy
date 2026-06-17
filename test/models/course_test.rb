require "test_helper"

class CourseTest < ActiveSupport::TestCase
  test "requires a title" do
    assert_not Course.new(title: nil).valid?
  end

  test "autogenerates a slug from the title" do
    course = Course.create!(title: "Hello Brave World")
    assert_equal "hello-brave-world", course.slug
  end

  test "slug must be unique" do
    Course.create!(title: "Dup", slug: "dup")
    assert_not Course.new(title: "Other", slug: "dup").valid?
  end

  test "published scope only returns published courses" do
    shown = Course.create!(title: "Shown", published: true)
    Course.create!(title: "Hidden", published: false)
    assert_includes Course.published, shown
    assert_equal 1, Course.published.count
  end

  test "progress is not_started without enrollment" do
    user = User.create!(name: "U", email: "u1@test.x")
    course = create_course_with_lessons(count: 2)

    progress = course.progress_for(user)

    assert_equal :not_started, progress.status
    assert_equal 0, progress.percent
    assert_equal 2, progress.total
    assert_equal 10, progress.estimated_minutes
  end

  test "progress is in_progress and counts percent after partial completion" do
    user = User.create!(name: "U", email: "u2@test.x")
    course = create_course_with_lessons(count: 2)
    course.enrollments.create!(user: user)
    LessonCompletion.create!(user: user, lesson: course.lessons.first)

    progress = course.progress_for(user)

    assert_equal :in_progress, progress.status
    assert_equal 1, progress.completed
    assert_equal 50, progress.percent
  end
end
