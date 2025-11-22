class CreateSubjects < ActiveRecord::Migration[8.1]
  def change
    create_table :subjects do |t|
      t.references :course, null: false, foreign_key: true
      t.string :code
      t.string :name
      t.text :description
      t.integer :credit_points
      t.text :prerequisites

      t.timestamps
    end
  end
end
