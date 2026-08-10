class CreateConferences < ActiveRecord::Migration[8.1]
  def change
    create_table "conferences", id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string "name", null: false
      t.date "held_on"
      t.string "venue"
      t.timestamps null: false
    end
  end
end
