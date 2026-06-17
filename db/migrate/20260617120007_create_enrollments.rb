class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer  :status, null: false, default: 0
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
    add_index :enrollments, [:user_id, :course_id], unique: true
  end
end
