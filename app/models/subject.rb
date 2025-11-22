class Subject < ApplicationRecord
  belongs_to :course

  validates :code, presence: true
  validates :name, presence: true

  serialize :prerequisite_groups, coder: JSON
  serialize :concurrent_subjects, coder: JSON

  # Parse prerequisites on save
  before_save :parse_prerequisites

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

  # Check if prerequisites are met given completed subjects
  # prerequisite_groups format: [["CAB301"], ["CAB302"], ["IFN582", "IFN584"]]
  # Outer array = OR (any group works), Inner arrays = AND (all in group needed)
  def prerequisites_met?(completed_codes)
    # If no prerequisites at all, return true
    return true if prerequisites.blank?

    # Parse prerequisites if not already parsed
    if prerequisite_groups.blank?
      parse_prerequisites
    end

    # If still blank after parsing, no subject prerequisites (might be CP only)
    return true if prerequisite_groups.blank?

    # Parse JSON if it's still a string (can happen with .select())
    groups = prerequisite_groups.is_a?(String) ? JSON.parse(prerequisite_groups) : prerequisite_groups

    # ANY of the groups must be satisfied (OR logic)
    groups.any? do |group|
      # ALL codes in the group must be completed (AND logic)
      group.all? { |code| completed_codes.include?(code) }
    end
  end

  # Get list of subjects that can be taken concurrently with this one
  def concurrent_codes
    concurrent_subjects || []
  end

  private

  def parse_prerequisites
    return unless prerequisites.present?

    # Extract concurrent subjects: "CAB201 concurrent ok" or "(CAB201 concurrent)"
    concurrent = []
    prereq_text = prerequisites.dup

    # Find concurrent mentions
    prereq_text.scan(/\(?([\w\d]+)\s+concurrent\s*(ok)?\)?/i) do |match|
      concurrent << match[0]
    end

    # Remove concurrent mentions from text
    prereq_text.gsub!(/\(?([\w\d]+)\s+concurrent\s*(ok)?\)?/i, '')

    # Parse prerequisite groups
    # Format: [["CAB301"], ["CAB302"], ["IFN582", "IFN584"]]
    # Outer array = OR (any group), Inner arrays = AND (all in group)
    groups = []

    # First, split by 'or' to get all OR options
    or_parts = prereq_text.split(/\s+or\s+/i)

    or_parts.each do |part|
      part = part.strip
      next if part.empty?

      # Check if this part has parentheses with AND
      if part.match(/\(([^)]+)\)/)
        # Extract content within parentheses
        inner = part.match(/\(([^)]+)\)/)[1]

        # Split by 'and' to get AND group
        codes = []
        inner.split(/\s+and\s+/i).each do |item|
          if match = item.match(/\b([A-Z]{3}\d{3})\b/)
            codes << match[1]
          end
        end

        groups << codes if codes.any?
      else
        # Single subject code
        if match = part.match(/\b([A-Z]{3}\d{3})\b/)
          groups << [match[1]]
        end
      end
    end

    self.prerequisite_groups = groups if groups.any?
    self.concurrent_subjects = concurrent if concurrent.any?
  end
end
