# == 抢单计划的执行记录
#
#  plan_id         :integer  计划
#  virtual_user_id :integer  虚拟账户
#  order_no        :string   成功的订单号
#  failed_step     :string   在哪一步失败
#  error_message   :string   错误信息
#
class Record < ApplicationRecord
  belongs_to :plan
  belongs_to :virtual_user
end
