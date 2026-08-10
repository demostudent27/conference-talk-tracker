class CreateSpeakers < ActiveRecord::Migration[8.1]
  def change
    create_table "speakers", id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string "name", null: false
      t.text "bio"
      t.string "website"
      t.timestamps null: false
    end
  end
end
