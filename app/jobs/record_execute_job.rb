class RecordExecuteJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    logger.info "record(#{record_id})开始执行..."
    record = Record.find record_id
    RecordExecutor.new(record).run
  end
end
