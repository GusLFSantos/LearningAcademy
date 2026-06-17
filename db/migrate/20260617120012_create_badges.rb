class CreateBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :badges do |t|
      t.references :course, null: false, foreign_key: true, index: { unique: true }
      t.string :name, null: false
      t.text   :description
      t.string :icon

      t.timestamps
    end
  end
end
