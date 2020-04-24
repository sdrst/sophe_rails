class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.string :project_id, foreign_key: true
      t.text :goal_text
      t.date :expected_date
      t.date :completed_date
    end
  end
end
