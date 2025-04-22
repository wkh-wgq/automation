class CreateRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :records do |t|
      t.references :company, null: false
      t.references :plan, null: false
      t.references :account, null: false
      t.string :state, null: false, default: 'pending'
      t.integer :failed_step
      t.text :error_message

      t.timestamps

      t.index [ :plan_id, :account_id ], unique: true
    end
  end
end
