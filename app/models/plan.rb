# == 抢单计划
#
#  link         :string   抢购链接
#  product_name :string   商品名称
#  quantity     :integer  抢购数量
#  batch_size   :integer  批次大小(需要多少账号去抢)
#  execute_time :time     抢购时间
#
class Plan < ApplicationRecord
  has_many :records

  after_create_commit :sync_execute

  validates :quantity, numericality: { greater_than: 0 }
  validates :batch_size, numericality: { greater_than: 0 }
  validate :validate_product

  # 计划创建完之后创建异步的定时任务
  def sync_execute
    BkmBatchGrabOrderJob.perform_later(self.id)
  end

  def statistics
    {
      successful_num: self.records.successful.count,
      failed_num: self.records.failed.count
    }
  end

  def validate_product
    if link.blank? && product_name.blank?
      raise "请填写商品链接或者商品名称！"
    end
  end
end
