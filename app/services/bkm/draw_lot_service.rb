require "playwright"
module Bkm
  class DrawLotService < BaseService
    attr_reader :page
    def initialize(record)
      super
      # user_agent = Faker::Internet.user_agent
      @playwright_exec = Playwright.create(playwright_cli_executable_path: "./node_modules/.bin/playwright")
      @browser = @playwright_exec.playwright.chromium.launch(headless: false)
      @page = @browser.new_page
      @login_retry_count = 0
    end

    def run
      %w[login go_product_page queue_up draw_lot confirm].each do |method|
        send(:execute_with_log, method)
      end
      logger.info "用户(#{virtual_user.email})抽签完成，等待抽签结果"
    rescue Exception => _e
      logger.error "用户(#{virtual_user.email})抽签流程异常结束"
    ensure
      page.close
      @browser.close
      @playwright_exec.stop
    end

    def login
      page.goto("https://www.pokemoncenter-online.com/login/", waitUntil: "domcontentloaded")
      raise "网络被限制访问！" if page.title == RESTRICTED_ACCESS_TITLE
      page.locator("#login-form-email").type(virtual_user.email, delay: rand(30..80))
      page.locator("#current-password").type(virtual_user.password, delay: rand(30..80))
      sleep(rand(0.5..2))
      page.locator("#form1Button").click
      sleep(rand(6..10))
      unless page.url == MY_URL
        raise "登陆失败！" if @login_retry_count >= 5
        @login_retry_count += 1
        login
      end
    end

    def go_product_page
      page.goto(plan.link)
    end

    def queue_up
      return if page.title != QUEUE_UP_TITLE
      logger.info "用户(#{virtual_user.email})开始排队"
      while (page.wait_for_load_state(state: "load"); page.title == QUEUE_UP_TITLE)
        sleep 5
      end
      # while !page.locator("#buttonConfirmRedirect").visible?
      #   sleep 5
      # end
      logger.info "用户(#{virtual_user.email})排队完成"
      sleep rand(4.0..8.0)
      # 点击进入网站按钮
      # page.locator("#buttonConfirmRedirect").click
      # logger.info "用户(#{virtual_user.email})进入网站"
    end

    def draw_lot
      page.locator("#step3Btn").click
      sleep(rand(4.0..8.0))
      page.click("text=\u8A73\u3057\u304F\u898B\u308B")
      sleep(rand(0.5..2.0))
      page.click("p.radio label")
      sleep(rand(0.5..2.0))
      page.locator("#L0000000004").click
      sleep(rand(0.5..2.0))
      page.click("a.popup-modal.on")
      sleep(rand(0.5..2.0))
      page.locator("#applyBtn").click
    end

    def confirm
      sleep(rand(2.0..4.0))
      page.goto "https://www.pokemoncenter-online.com/lottery-history/"
      sleep(rand(3.0..5.0))
    end

    def execute_with_log(method)
      logger.debug "用户(#{virtual_user.email})抢单-(#{method})流程开始"
      send(method)
      logger.debug "用户(#{virtual_user.email})抢单-(#{method})流程结束"
    rescue Exception => e
      logger.error "用户(#{virtual_user.email})抢单-(#{method})流程异常：#{e.message}"
      record.update(failed_step: method, error_message: e.message)
      raise e
    end
  end
end
