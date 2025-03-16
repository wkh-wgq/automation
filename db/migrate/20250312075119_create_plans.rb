class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans, comment: '抢单计划' do |t|
      t.string :link, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :batch_size, null: false
      t.datetime :execute_time, null: false

      t.timestamps
    end
  end
end
