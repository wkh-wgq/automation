module Bkm
  class SendRegisterEmailJob < ApplicationJob
    queue_as :default

    def perform(record_id)
      logger.info "auto_register_record(#{record_id})开始发送注册邮件..."
      record = AutoRegisterRecord.find record_id
      Bkm::AutoRegisterService.new(record).send_email
    end
  end
end
