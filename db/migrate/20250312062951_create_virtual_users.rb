class CreateVirtualUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :virtual_users do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.belongs_to :address, null: false, foreign_key: true
      t.belongs_to :credit_card, null: false, foreign_key: true

      t.timestamps

      t.index :email, unique: true
    end
  end
end
