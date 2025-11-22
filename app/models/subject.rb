class Subject < ApplicationRecord
  belongs_to :course

  validates :code, presence: true
  validates :name, presence: true

  def prerequisite_codes
    return [] unless prerequisites.present?

    # Split by comma and filter out CP requirements
    prerequisites.split(',').map(&:strip).reject { |p| p.match?(/\d+\s*CP/i) }
  end

  def required_cp
    return 0 unless prerequisites.present?

    # Extract CP requirement (e.g., "144 CP required" -> 144)
    match = prerequisites.match(/(\d+)\s*CP/i)
    match ? match[1].to_i : 0
  end
end
