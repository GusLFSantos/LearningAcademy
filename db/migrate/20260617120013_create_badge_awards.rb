class CreateBadgeAwards < ActiveRecord::Migration[8.1]
  def change
    create_table :badge_awards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :badge, null: false, foreign_key: true
      t.datetime :awarded_at, null: false

      t.timestamps
    end
    add_index :badge_awards, [ :user_id, :badge_id ], unique: true
  end
end
