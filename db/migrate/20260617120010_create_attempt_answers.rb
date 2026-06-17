class CreateAttemptAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :attempt_answers do |t|
      t.references :quiz_attempt, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer_option, null: false, foreign_key: true

      t.timestamps
    end
    add_index :attempt_answers, [ :quiz_attempt_id, :question_id ], unique: true
  end
end
