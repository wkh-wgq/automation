# 宝可梦抢单 service
module Bkm
  class NormalService < BaseService
    attr_reader :driver
    def initialize(record)
      super
      @driver = EdgeDriver.build
    end

    def run
      %w[prepare go_product_page select_quantity add_cart login submit_order fill_order_no].each do |method|
        send(:execute_with_log, method)
      end
      logger.info "用户(#{virtual_user.email})下单完成，订单号：#{record.order_no}"
    rescue Exception => _e
      logger.error "用户(#{virtual_user.email})下单流程异常结束"
    ensure
      driver.quit
    end

    # 预备环节，看网络是否被拦截，是否需要排队
    def prepare
      driver.get "https://www.pokemoncenter-online.com"
      raise "网络被限制访问！" if driver.title == RESTRICTED_ACCESS_TITLE
      # 排队
      if driver.title == QUEUE_UP_TITLE
        logger.info "用户(#{virtual_user.email})开始排队"
        while driver.title == QUEUE_UP_TITLE
          sleep 1
        end
        logger.info "用户(#{virtual_user.email})排队完成，开始下单"
      end
    end

    # 前往商品页面
    def go_product_page
      url = Rails.cache.fetch("bkm.product.page_url-#{plan.id}", expires_in: 60.minutes) do
        plan.link.present? ? plan.link : get_target_product_page_url
      end
      driver.get url
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
          1
        end.tap do |num|
          logger.info "获取抢购数量：#{num}"
        end
      end
    end

    # 前往新品页面，根据商品名称查询链接
    def get_target_product_page_url
      logger.debug "开始为商品(#{plan.product_name})查询链接"
      # 前往新品页面
      driver.get "https://www.pokemoncenter-online.com/search/?prefn1=releaseType&prefv1=1&srule=top-new-product"
      product_tag = detect_product_tag
      # 如果找不到商品，就一直点击下一页，直到点不动为止
      while product_tag.blank?
        begin
          # 点击下一页
          driver.find_element(class: "next").click
        rescue Selenium::WebDriver::Error::ElementClickInterceptedError => _e
          raise "获取商品(#{plan.product_name})链接失败：找不到商品"
        end
        product_tag = detect_product_tag
      end
      "https://www.pokemoncenter-online.com/#{product_tag.attribute("data-pid")}.html".tap do |url|
        logger.info "获取目标商品的url：#{url}"
      end
    end

    # 在新品列表查找目标商品
    def detect_product_tag
      driver.find_element(class: "comltemlist").find_elements(class: "product").detect do |p|
        plan.product_name == p.find_element(class: "txtBox").find_element(class: "txt").text
      end
    end
  end
end
