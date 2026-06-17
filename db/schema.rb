# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_17_120013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answer_options", force: :cascade do |t|
    t.string "body", null: false
    t.boolean "correct", default: false, null: false
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.bigint "question_id", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "position"], name: "index_answer_options_on_question_id_and_position"
    t.index ["question_id"], name: "index_answer_options_on_question_id"
  end

  create_table "attempt_answers", force: :cascade do |t|
    t.bigint "answer_option_id", null: false
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.bigint "quiz_attempt_id", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_option_id"], name: "index_attempt_answers_on_answer_option_id"
    t.index ["question_id"], name: "index_attempt_answers_on_question_id"
    t.index ["quiz_attempt_id", "question_id"], name: "index_attempt_answers_on_quiz_attempt_id_and_question_id", unique: true
    t.index ["quiz_attempt_id"], name: "index_attempt_answers_on_quiz_attempt_id"
  end

  create_table "badge_awards", force: :cascade do |t|
    t.datetime "awarded_at", null: false
    t.bigint "badge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["badge_id"], name: "index_badge_awards_on_badge_id"
    t.index ["user_id", "badge_id"], name: "index_badge_awards_on_user_id_and_badge_id", unique: true
    t.index ["user_id"], name: "index_badge_awards_on_user_id"
  end

  create_table "badges", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_badges_on_course_id", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.string "slug", null: false
    t.string "summary"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_courses_on_position"
    t.index ["slug"], name: "index_courses_on_slug", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.datetime "completed_at"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "started_at"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "lesson_completions", force: :cascade do |t|
    t.datetime "completed_at", null: false
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["lesson_id"], name: "index_lesson_completions_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_lesson_completions_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_lesson_completions_on_user_id"
  end

  create_table "lesson_time_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.integer "seconds", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["lesson_id"], name: "index_lesson_time_logs_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_lesson_time_logs_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_lesson_time_logs_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.text "body"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.integer "estimated_minutes", default: 5, null: false
    t.integer "position", default: 0, null: false
    t.boolean "published", default: true, null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "position"], name: "index_lessons_on_course_id_and_position"
    t.index ["course_id", "slug"], name: "index_lessons_on_course_id_and_slug", unique: true
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.text "prompt", null: false
    t.bigint "quiz_id", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id", "position"], name: "index_questions_on_quiz_id_and_position"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.boolean "passed", default: false, null: false
    t.bigint "quiz_id", null: false
    t.integer "score"
    t.datetime "started_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["quiz_id"], name: "index_quiz_attempts_on_quiz_id"
    t.index ["user_id", "quiz_id"], name: "index_quiz_attempts_on_user_id_and_quiz_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.integer "pass_percentage", default: 70, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_quizzes_on_lesson_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answer_options", "questions"
  add_foreign_key "attempt_answers", "answer_options"
  add_foreign_key "attempt_answers", "questions"
  add_foreign_key "attempt_answers", "quiz_attempts"
  add_foreign_key "badge_awards", "badges"
  add_foreign_key "badge_awards", "users"
  add_foreign_key "badges", "courses"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
  add_foreign_key "lesson_completions", "lessons"
  add_foreign_key "lesson_completions", "users"
  add_foreign_key "lesson_time_logs", "lessons"
  add_foreign_key "lesson_time_logs", "users"
  add_foreign_key "lessons", "courses"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quiz_attempts", "quizzes"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "quizzes", "lessons"
end
