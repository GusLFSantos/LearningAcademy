class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.references :lesson, null: false, foreign_key: true, index: { unique: true }
      t.string  :title
      t.integer :pass_percentage, null: false, default: 70

      t.timestamps
    end
  end
end
