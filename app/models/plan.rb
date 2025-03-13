# 抢单计划
class Plan < ApplicationRecord
  has_many :records

  after_create_commit :sync_execute

  # 计划创建完之后创建异步的定时任务
  def sync_execute
    BkmBatchGrabOrderJob.perform_later(self.id)
  end
end
