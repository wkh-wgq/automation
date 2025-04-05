class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :postal_code, comment: '邮政编码'
      t.string :house_number, comment: '门牌号'
      t.string :street_address, comment: '地址'

      t.timestamps
    end
  end
end
