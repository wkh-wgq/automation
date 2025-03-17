class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans, comment: '抢单计划' do |t|
      t.string :link
      t.integer :quantity, default: 1
      t.integer :batch_size, null: false
      t.datetime :execute_time

      t.timestamps
    end
  end
end
