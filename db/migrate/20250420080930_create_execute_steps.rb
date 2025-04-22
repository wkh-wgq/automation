class CreateExecuteSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :execute_steps do |t|
      t.references :plan, null: false
      t.string :type, null: false, comment: '操作类型(system/custom)'
      t.string :element, comment: '页面定位的元素'
      t.string :action, null: false, comment: '执行的action'
      t.string :action_value

      t.timestamps
    end
  end
end
