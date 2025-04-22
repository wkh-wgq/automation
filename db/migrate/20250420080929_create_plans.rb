class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :title
      t.references :company, null: false
      t.datetime :execute_time

      t.timestamps
    end
  end
end
