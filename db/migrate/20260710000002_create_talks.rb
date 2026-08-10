class CreateTalks < ActiveRecord::Migration[8.1]
  def change
    create_table "talks", id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string "title", null: false
      t.text "description"
      t.integer "duration_minutes"
      t.string "slides_url"
      t.boolean "is_keynote"
      t.uuid "speaker_id", null: false
      t.uuid "conference_id", null: false
      t.timestamps null: false
      t.index ["speaker_id"], name: "index_talks_on_speaker_id"
      t.index ["conference_id"], name: "index_talks_on_conference_id"
    end
  end
end
