class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :postal_code
      t.string :city
      t.string :street_address

      t.timestamps
    end
  end
end
