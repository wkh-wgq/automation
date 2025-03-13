class BkmBatchGrabOrderJob < ApplicationJob
  queue_as :default

  def perform(plan_id)
    logger.info "触发宝可梦批量抢单操作(#{record_id})"
    plan = Plan.find plan_id
    VirtualUser.take(plan.batch_size).each do |user|
      record = plan.records.create!(virtual_user: user)
      BkmGrabOrderJob.set(wait_until: plan.execute_time).perform_later(record.id)
    end
  end
end
