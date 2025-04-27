class CreateEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :emails do |t|
      t.string :email, null: false
      t.integer :parent_id, comment: '父id,企业邮箱会有转发的情况'
      t.string :domain, comment: '域名'
      t.string :imap_password
      t.string :mobile

      t.timestamps

      t.index :email, unique: true
      t.index :parent_id
    end
  end
end
