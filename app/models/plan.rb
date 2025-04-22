class Plan < ApplicationRecord
  belongs_to :company
  has_many :steps, class_name: "ExecuteStep", inverse_of: :plan, autosave: true
  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank
  after_update_commit :clear_steps_cache

  def clear_steps_cache
    Rails.cache.delete("plan.steps-#{self.id}")
  end
end
