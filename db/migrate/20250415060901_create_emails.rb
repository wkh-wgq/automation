class CreateEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :emails do |t|
      t.string :email
      t.string :parent_id
      t.string :domain
      t.string :imap_password
      t.string :mobile

      t.timestamps

      t.index :email, unique: true
      t.index :parent_id
    end
  end
end
