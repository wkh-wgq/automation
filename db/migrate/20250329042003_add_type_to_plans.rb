class AddTypeToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :type, :string, null: false, default: 'normal', comment: '抢购类型(正常 normal/抽签 draw_lot)'
  end
end
