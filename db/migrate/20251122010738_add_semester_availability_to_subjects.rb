class AddSemesterAvailabilityToSubjects < ActiveRecord::Migration[8.1]
  def change
    add_column :subjects, :semester_availability, :string
  end
end
