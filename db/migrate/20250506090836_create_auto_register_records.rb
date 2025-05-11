class CreateAutoRegisterRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :auto_register_records do |t|
      t.references :company, null: false
      t.references :virtual_user, null: false
      t.references :address, null: false
      t.string :email, null: false
      t.string :state, null: false, default: 'pending'
      t.string :error_message
      t.json :properties

      t.timestamps

      t.index [ :virtual_user_id, :company_id ], unique: true
      t.index [ :email, :company_id ], unique: true
    end
  end
end
