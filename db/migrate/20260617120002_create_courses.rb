class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string  :title, null: false
      t.string  :slug, null: false
      t.string  :summary
      t.text    :description
      t.integer :position, null: false, default: 0
      t.boolean :published, null: false, default: false

      t.timestamps
    end
    add_index :courses, :slug, unique: true
    add_index :courses, :position
  end
end
