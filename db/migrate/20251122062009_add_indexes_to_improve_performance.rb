class AddIndexesToImprovePerformance < ActiveRecord::Migration[8.1]
  def change
    # Add index on users.email for faster lookups during authentication
    add_index :users, :email, unique: true unless index_exists?(:users, :email)

    # Add index on subjects.code for faster prerequisite lookups
    add_index :subjects, :code unless index_exists?(:subjects, :code)

    # Add composite index on subjects for common queries
    add_index :subjects, [:course_id, :unit_type] unless index_exists?(:subjects, [:course_id, :unit_type])
  end
end
