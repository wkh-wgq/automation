class AddMobileToVirtualUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :virtual_users, :mobile, :string
  end
end
