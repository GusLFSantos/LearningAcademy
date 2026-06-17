require "application_system_test_case"

class LearningFlowSystemTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(name: "Learner", email: "sys@test.x")
    @course = Course.create!(
      title: "System Course", summary: "An end-to-end course", published: true,
      description: "# Welcome\n\nLet's learn."
    )
    Badge.create!(course: @course, name: "System Badge", icon: "🎖️")

    @lesson = @course.lessons.create!(
      title: "Only Lesson", position: 1, estimated_minutes: 5,
      body: <<~'MD'
        ## Concept

        ```ruby
        puts "hi"
        ```

        ```mermaid
        flowchart LR
          Start --> Finish
        ```
      MD
    )
    quiz = @lesson.create_quiz!(title: "Quiz", pass_percentage: 70)
    question = quiz.questions.create!(prompt: "Pick the right answer", position: 1)
    question.answer_options.create!(body: "Right", correct: true, position: 1)
    question.answer_options.create!(body: "Wrong", correct: false, position: 2)
  end

  test "mermaid diagram renders to an SVG on the lesson page" do
    visit course_lesson_path(@course, @lesson)
    assert_text "Concept"
    # Mermaid replaces <pre class="mermaid"> with rendered <svg>.
    assert_selector "article svg", wait: 20
    take_screenshot
  end

  test "learner enrolls, passes the quiz, and earns the badge" do
    visit course_path(@course)
    click_on "Enroll in this course"
    assert_text "In progress"

    click_on "Only Lesson"
    assert_text "min read"
    click_on "Take the quiz"

    choose "Right"
    click_on "Submit answers"

    assert_text "Passed"
    take_screenshot

    visit profile_path
    assert_text "System Badge"
    assert_text "Completed"
  end
end
