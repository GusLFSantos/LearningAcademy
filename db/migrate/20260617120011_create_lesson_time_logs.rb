class CreateLessonTimeLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :lesson_time_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.integer :seconds, null: false, default: 0

      t.timestamps
    end
    add_index :lesson_time_logs, [ :user_id, :lesson_id ], unique: true
  end
end
