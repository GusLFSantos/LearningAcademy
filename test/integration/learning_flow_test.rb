require "test_helper"

# Exercises the full HTTP journey. current_user is stubbed to User.first, so the
# single user created here is "the learner".
class LearningFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Learner", email: "flow@test.x")
    @course = create_course_with_lessons(count: 2)
    @l1, @l2 = @course.lessons.ordered.to_a
  end

  test "enroll, accrue time, and pass quizzes to earn the badge" do
    # Enroll
    post course_enrollment_path(@course)
    assert_redirected_to course_path(@course)
    assert @course.reload.enrolled?(@user)
    assert_equal :in_progress, @course.status_for(@user)

    # Read a lesson
    get course_lesson_path(@course, @l1)
    assert_response :success

    # Accrue active time
    post course_lesson_time_logs_path(@course, @l1), params: { seconds: 40 }
    assert_response :no_content
    assert_equal 40, LessonTimeLog.find_by(user: @user, lesson: @l1).seconds

    # Fail the first quiz (wrong answer) -> lesson stays incomplete
    q = @l1.quiz.questions.first
    post course_lesson_quiz_attempts_path(@course, @l1),
         params: { answers: { q.id.to_s => q.answer_options.find_by(correct: false).id.to_s },
                   started_at: 5.seconds.ago.iso8601 }
    assert_not @l1.completed_by?(@user)

    # Pass both quizzes
    [@l1, @l2].each do |lesson|
      post course_lesson_quiz_attempts_path(@course, lesson),
           params: { answers: correct_answers_for(lesson.quiz), started_at: 10.seconds.ago.iso8601 }
      assert_response :redirect
    end

    assert @l1.completed_by?(@user)
    assert @l2.completed_by?(@user)
    assert_equal :completed, @course.status_for(@user)
    assert @course.badge.earned_by?(@user)

    # Profile shows the earned badge
    get profile_path
    assert_response :success
    assert_match @course.badge.name, response.body
  end

  test "course progress reaches 100 percent after completing lessons" do
    post course_enrollment_path(@course)
    [@l1, @l2].each do |lesson|
      post course_lesson_quiz_attempts_path(@course, lesson),
           params: { answers: correct_answers_for(lesson.quiz) }
    end
    assert_equal 100, @course.progress_for(@user).percent
  end
end
