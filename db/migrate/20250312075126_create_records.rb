class CreateRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :records, comment: '抢单计划的执行记录' do |t|
      t.belongs_to :plan, null: false, foreign_key: true
      t.belongs_to :virtual_user, null: false, foreign_key: true
      t.string :order_no, comment: '成功的订单号'
      t.string :failed_step, comment: '失败的步骤'
      t.string :error_message, comment: '错误信息'

      t.timestamps

      t.index [ :plan_id, :virtual_user_id ], unique: true
    end
  end
end
