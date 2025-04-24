#
# == 计划
# @attr[String] title
# @attr[Integer]  company_id
# @attr[Time] execute_time
#
class Plan < ApplicationRecord
  belongs_to :company
  has_many :steps, class_name: "ExecuteStep"
  has_many :records, inverse_of: :plan
  after_update_commit :clear_steps_cache

  def clear_steps_cache
    Rails.cache.delete("plan.steps-#{self.id}")
  end
end
