class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :account_no
      t.references :company, null: false
      t.references :user, null: false
      t.references :address
      t.references :payment
      t.string :password
      t.datetime :last_login_time

      t.timestamps

      t.index [ :account_no, :company_id ], unique: true
    end
  end
end
