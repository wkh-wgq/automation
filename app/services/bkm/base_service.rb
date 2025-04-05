module Bkm
  class BaseService < ::ApplicationService
    # 排队的页面title
    QUEUE_UP_TITLE = "Queue-it"
    # 限制访问的页面title
    RESTRICTED_ACCESS_TITLE = "Restricted access"
    # 首页url
    ROOT_URL = "https://www.pokemoncenter-online.com"
    # 我的页面
    MY_URL = "https://www.pokemoncenter-online.com/mypage/"

    attr_accessor :record
    delegate :virtual_user, :plan, to: :record
    def initialize(record)
      @record = record
      logger.info "用户(#{virtual_user.email})开始加载驱动"
    end

    def execute_with_log(method)
      logger.debug "用户(#{virtual_user.email})抢单-(#{method})流程开始"
      send(method)
      logger.debug "用户(#{virtual_user.email})抢单-(#{method})流程结束"
    rescue Exception => e
      logger.error "用户(#{virtual_user.email})抢单-(#{method})-页面(#{driver.title})流程异常：#{e.message}"
      record.update(failed_step: method, error_message: e.message)
      raise e
    end
  end
end
