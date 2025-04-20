class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :company, null: false
      t.string :mode
      t.json :info

      t.timestamps
    end
  end
end
