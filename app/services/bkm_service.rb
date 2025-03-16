# 宝可梦抢单 service
class BkmService < ApplicationService
  attr_accessor :record
  attr_reader :driver
  delegate :virtual_user, :plan, to: :record
  def initialize(record)
    @record = record
    logger.info "用户(#{virtual_user.email})下单开始加载驱动"
    @driver = EdgeDriver.build
  end

  def run
    # 前往商品页面
    driver.get plan.link
    %w[select_quantity add_cart login submit_order fill_order_no].each do |method|
      send(:execute_with_log, method)
    end
    logger.info "用户(#{virtual_user.email})下单完成，订单号：#{record.order_no}"
  rescue Exception => _e
    logger.error "用户(#{virtual_user.email})下单流程异常结束"
  ensure
    driver.quit
  end

  # 登陆
  def login
    retry_count = 0
    _login
    # 如果碰到reCAPTCHA验证，则刷新页面重新登陆，实际操作发现重试有用
    while driver.find_element(class: "comErrorBox").text.present?
      if retry_count < 10
        refresh
        _login
        retry_count += 1
      else
        raise "登陆失败：#{driver.find_element(class: "comErrorBox").text}"
      end
    end
  end

  # 选择数量
  def select_quantity
    select_element = driver.find_element(:id, "quantity")
    select = Selenium::WebDriver::Support::Select.new(select_element)
    select.select_by(:index, get_quantity - 1)
  end

  # 加入购物车
  def add_cart
    driver.find_element(link_text: "カートに入れる").click
    driver.find_element(link_text: "注文手続きへ進む").click
    driver.find_element(link_text: "レジに進む").click
  end

  # 提交订单
  def submit_order
    driver.find_element(class: "submit-shipping").click
    driver.find_element(link_text: "ご注文内容を確認する").click
    driver.find_element(link_text: "注文を確定する").click
  end

  # 回填订单号
  def fill_order_no
    # 这里会出现银行的redirect加载页面，所以需要等待，在这里sleep20秒也没关系，订单已经ok了
    sleep 20
    order_no = driver.find_element(class: "numberTxt").find_element(class: "txt").text
    record.update(order_no: order_no, failed_step: nil, error_message: nil)
  end

  def _login
    driver.find_element(:id, "login-form-email").send_keys(virtual_user.email)
    driver.find_element(:id, "current-password").send_keys(virtual_user.password)
    driver.find_element(:id, "form1Button").click
  end

  # 刷新页面
  def refresh
    driver.navigate.refresh
  end

  # 获取购买数量，取计划的数量和商品限购数量的最小值
  def get_quantity
    Rails.cache.fetch("bkm.product.limit-#{plan.id}", expires_in: 60.minutes) do
      begin
        cache_limit = driver.find_element(class: "limit").text.scan(/\d+/).first.to_i
        [ cache_limit, plan.quantity ].min
      rescue Exception => _e
        plan.quantity
      end.tap do |num|
        logger.info "获取抢购数量：#{num}"
      end
    end
  end

  def execute_with_log(method)
    logger.debug "用户(#{virtual_user.email})下单-(#{method})流程开始"
    send(method)
    logger.debug "用户(#{virtual_user.email})下单-(#{method})流程结束"
  rescue Exception => e
    logger.error "用户(#{virtual_user.email})下单-(#{method})流程异常：#{e.message}"
    record.update(failed_step: method, error_message: e.message)
    raise e
  end
end
