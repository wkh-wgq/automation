class Bkm::AutoRegisterJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    logger.info "auto_register_record(#{record_id})开始注册..."
    record = AutoRegisterRecord.find record_id
    Bkm::AutoRegisterService.new(record).register
  end
end
