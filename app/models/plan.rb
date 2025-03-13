# == 抢单计划
#
#  link         :string   抢购链接
#  quantity     :integer  抢购数量
#  batch_size   :integer  批次大小(需要多少账号去抢)
#  execute_time :time     抢购时间
#
class Plan < ApplicationRecord
  has_many :records

  after_create_commit :sync_execute

  # 计划创建完之后创建异步的定时任务
  def sync_execute
    BkmBatchGrabOrderJob.perform_later(self.id)
  end
end
