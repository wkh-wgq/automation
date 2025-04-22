module SystemStep
  class BkmService < BaseService
    attr_reader :page, :record
    delegate :account, to: :record
    def initialize(page, record)
      @page = page
      @record = record
      @login_retry_count = 0
    end

    def login
      page.goto("https://www.pokemoncenter-online.com/login/", waitUntil: "domcontentloaded")
      raise "网络被限制访问！" if page.title == RESTRICTED_ACCESS_TITLE
      page.locator("#login-form-email").type(account.account_no, delay: rand(30..80))
      page.locator("#current-password").type(account.password, delay: rand(30..80))
      sleep(rand(0.5..2))
      page.locator("#form1Button").click
      sleep(rand(6..10))
      unless page.url == MY_URL
        raise "登陆失败！" if @login_retry_count >= 5
        @login_retry_count += 1
        login
      end
    end

    def queue_up
      return if page.title != QUEUE_UP_TITLE
      logger.info "用户(#{account.account_no})开始排队"
      while (page.wait_for_load_state(state: "load"); page.title == QUEUE_UP_TITLE)
        sleep 5
      end
      # while !page.locator("#buttonConfirmRedirect").visible?
      #   sleep 5
      # end
      logger.info "用户(#{account.account_no})排队完成"
      sleep rand(4.0..8.0)
      # 点击进入网站按钮
      # page.locator("#buttonConfirmRedirect").click
      # logger.info "用户(#{virtual_user.email})进入网站"
    end

    def human_delay
      sleep(rand(0.5..2.0))
    end
  end
end
