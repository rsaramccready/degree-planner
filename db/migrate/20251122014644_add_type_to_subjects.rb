class AddTypeToSubjects < ActiveRecord::Migration[8.1]
  def change
    add_column :subjects, :unit_type, :string
  end
end
