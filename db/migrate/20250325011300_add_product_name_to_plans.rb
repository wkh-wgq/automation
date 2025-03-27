class AddProductNameToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :product_name, :string
  end
end
