class Talk < ApplicationRecord
  belongs_to :speaker, class_name: "Speaker", foreign_key: "speaker_id", optional: false
  belongs_to :conference, class_name: "Conference", foreign_key: "conference_id", optional: false

  validates :title, presence: true
  validates :title, length: { maximum: 200, allow_nil: true }
  validates :duration_minutes, comparison: { greater_than: 0 }, allow_nil: true
end
