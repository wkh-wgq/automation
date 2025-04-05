class BkmGrabOrderJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    logger.info "触发宝可梦抢单操作(#{record_id})"
    record = Record.find record_id
    plan = record.plan
    klass = "Bkm::#{plan.type.classify}Service".constantize
    klass.new(record).run
  end
end
