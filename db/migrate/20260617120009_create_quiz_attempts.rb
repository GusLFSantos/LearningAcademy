class CreateQuizAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.integer  :score
      t.boolean  :passed, null: false, default: false
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
    add_index :quiz_attempts, [ :user_id, :quiz_id ]
  end
end
