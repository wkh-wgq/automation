class BkmRegisterJob < ApplicationJob
  queue_as :default

  def perform(email, phone, link)
    Bkm::AutoRegisterService.new.register(email, phone, link)
  end
end
