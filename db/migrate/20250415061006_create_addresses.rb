class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :company, null: false
      t.json :detail

      t.timestamps
    end
  end
end
