require "playwright"

class RecordExecutor < ApplicationService
  attr_reader :page, :account
  attr_accessor :record
  def initialize(record)
    @record = record
    @account = @record.account
    @plan = @record.plan
    @steps = Rails.cache.fetch("plan.steps-#{@plan.id}", expires_in: 30.minutes) do
      @plan.steps.order(:id).to_a
    end
    logger.info "用户(#{@account.account_no})开始加载驱动"
    @playwright_exec = Playwright.create(playwright_cli_executable_path: "./node_modules/.bin/playwright")
    @browser = @playwright_exec.playwright.chromium.launch(headless: false)
    @page = @browser.new_page
    @current_step_index = 0
    klass = "SystemStep::#{@plan.company.code.classify}Service".constantize
    @system_step_service = klass.new(@page, record)
  end

  def run
    message = "plan(#{@plan.id})没有配置steps" if @steps.blank?
    message = "record(#{record.id})状态异常，不做执行操作" unless record.executing?
    if message.present?
      record.to_fail(message)
      return logger.warn message
    end
    while @current_step_index < @steps.size
      current_step = @steps[@current_step_index]
      execute_step(current_step)
      @current_step_index += 1
    end
    record.complete!
  ensure
    page.close
    @browser.close
    @playwright_exec.stop
  end

  def execute_step(step)
    if step.system?
      block = -> { @system_step_service.send(step.action) }
    elsif step.action == "goto"
      block = -> { page.goto(step.action_value) }
    else
      args = [ step.action ]
      args << step.action_value if step.action_value.present?
      block = -> { page.locator(step.element).send(*args) }
    end
    execute_with_log(step, &block)
  end

  def execute_with_log(step, &block)
    logger.debug "记录(#{record.id})执行-#{step.action}"
    block.call
  rescue Exception => e
    logger.error "记录(#{record.id})的step(#{step.id})执行异常：#{e.message}"
    record.to_fail(e.message, step.id)
    raise e
  end
end
