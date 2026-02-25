class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :body
      t.integer :status, null: false, default: 0
      t.integer :priority, null: false, default: 0
      t.datetime :due_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
