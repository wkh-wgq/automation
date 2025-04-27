#
# == 执行记录
# @attr[Integer] company_id
# @attr[Integer] plan_id
# @attr[Integer] account_id
# @attr[String] state
# @attr[Integer] failed_step
# @attr[String] error_message
#
class Record < ApplicationRecord
  include AASM

  belongs_to :plan
  belongs_to :account
  belongs_to :company

  validates_uniqueness_of :account_id, scope: :plan_id

  aasm(:state) do
    # 待执行
    state :pending, initial: true
    # 执行中
    state :executing
    # 执行完成
    state :completed
    # 执行失败
    state :failed

    event :execute, after: :execute_by_job do
      transitions from: :pending, to: :executing
      transitions from: :failed, to: :executing
    end

    # 执行完成
    event :complete, before: :clear_error_message do
      transitions from: :executing, to: :completed
    end

    # 执行失败
    event :fail do
      transitions from: :executing, to: :failed
    end
  end

  def execute_by_job
    RecordExecuteJob.perform_later(self.id)
  end

  def to_fail(error_message, step_id = nil)
    self.assign_attributes(failed_step: step_id, error_message: error_message)
    self.fail!
  end

  def clear_error_message
    self.assign_attributes(failed_step: nil, error_message: nil)
  end

  private

    def auto_populate_attributes
      self.company ||= self.plan.company
    end
end
