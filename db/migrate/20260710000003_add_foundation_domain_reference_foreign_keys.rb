class AddFoundationDomainReferenceForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key "talks", "speakers", column: "speaker_id", on_delete: :restrict
    add_foreign_key "talks", "conferences", column: "conference_id", on_delete: :cascade
  end
end
