class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :course, null: false, foreign_key: true
      t.string  :title, null: false
      t.string  :slug, null: false
      t.text    :body
      t.integer :position, null: false, default: 0
      t.boolean :published, null: false, default: true
      t.integer :estimated_minutes, null: false, default: 5

      t.timestamps
    end
    add_index :lessons, [:course_id, :slug], unique: true
    add_index :lessons, [:course_id, :position]
  end
end
