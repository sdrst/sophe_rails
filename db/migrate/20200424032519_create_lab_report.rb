class CreateLabReport < ActiveRecord::Migration[6.0]
  def change
    create_table :lab_reports do |t|
      t.string :links
      t.string :project_id, foreign_key: true
      t.text :text
    end
  end
end
