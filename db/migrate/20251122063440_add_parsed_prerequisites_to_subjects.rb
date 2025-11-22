class AddParsedPrerequisitesToSubjects < ActiveRecord::Migration[8.1]
  def change
    # Store parsed prerequisites as JSON
    # Format: [["CAB201", "ITD121"], ["MZB151"]] means (CAB201 OR ITD121) AND MZB151
    add_column :subjects, :prerequisite_groups, :text

    # Store subjects that can be taken concurrently
    # Format: ["CAB201"] means CAB201 can be concurrent
    add_column :subjects, :concurrent_subjects, :text
  end
end
