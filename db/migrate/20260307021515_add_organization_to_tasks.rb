class AddOrganizationToTasks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :organization, null: false, foreign_key: true
  end
end
