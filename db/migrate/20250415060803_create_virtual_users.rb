class CreateVirtualUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :virtual_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :birthday
      t.string :mobile

      t.timestamps

      t.index :mobile, unique: true
    end
  end
end
