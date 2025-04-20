class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :code

      t.timestamps

      t.index :name, unique: true
      t.index :code, unique: true
    end
  end
end
