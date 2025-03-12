class CreateCreditCards < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_cards do |t|
      t.string :cardholder_name
      t.string :card_number
      t.string :expiration_date
      t.string :security_code

      t.timestamps
    end
  end
end
