require "net/imap"
require "playwright"
module Bkm
  class AutoRegisterService < ::ApplicationService
    LOGIN_URL = "https://www.pokemoncenter-online.com/login/"
    PASSWORD = "1234qwer."

    attr_reader :page
    def initialize
      user_agent = Faker::Internet.user_agent
      @playwright_exec = Playwright.create(playwright_cli_executable_path: "./node_modules/.bin/playwright")
      @browser = @playwright_exec.playwright.chromium.launch(
        headless: false,
        args: [
          "--disable-blink-features=AutomationControlled",
          "--lang=ja-JP",
          "--user-agent=#{user_agent}",
          "--use-fake-ui-for-media-stream", # 禁用媒体权限提示
          "--use-fake-device-for-media-stream"
        ]
      )
      @context = @browser.new_context(
        viewport: { width: 1366, height: 768 },
        locale: "ja-JP",
        timezoneId: "Asia/Tokyo",
        colorScheme: "light",
        userAgent: user_agent,
        # 随机化设备特征
        deviceScaleFactor: rand(1..2) == 2 ? 1.25 : 1.0,
        isMobile: false,
        hasTouch: false
      )
      @page = @context.new_page
      @page.add_init_script(script: <<~JS
        Object.defineProperty(navigator, 'webdriver', {
          get: () => false,
          configurable: true
        })

        Object.defineProperty(navigator, 'plugins', {
          get: () => [{
            name: 'Chrome PDF Viewer',
            filename: 'internal-pdf-viewer'
          }],
          configurable: true
        })

        # 修改硬件并发数
        Object.defineProperty(navigator, 'hardwareConcurrency', {
          value: 4,
          configurable: true
        })

        const getParameter = WebGLRenderingContext.prototype.getParameter
        WebGLRenderingContext.prototype.getParameter = function(parameter) {
          if (parameter === 37445) return 'Intel Inc.' // 伪装渲染器厂商
          if (parameter === 37446) return 'Intel Iris OpenGL Engine'
          return getParameter.call(this, parameter)
        }
      JS
      )
    end

    # params = {manager_email: "", manager_password: "", register_emails: { "email" => "phone" }}
    # Bkm::AutoRegisterService.new.run(params)
    #
    # 获取注册链接
    def run(params)
      # 发送注册链接的邮件
      send_email(params[:register_emails])
      # 等待邮件发送
      # sleep 10
      # 读取邮件生成注册job
      # resolve_email(params)
    end

    # 填写信息进行注册
    def register(email, phone, link)
      if VirtualUser.where(email: email).count > 0
        return logger.warn "(#{email})已经注册！"
      end
      address = Address.first
      page.goto(link)
      human_delay
      # 填写姓名
      name = email.split("@")[0]
      page.locator("#registration-form-fname").type(name, delay: rand(50..120))
      human_delay
      page.locator("#registration-form-kana").type(name, delay: rand(50..120))
      # random_scroll
      human_delay
      # 选择生日
      birthday = Faker::Date.birthday(min_age: 18, max_age: 50)
      page.locator("#registration-form-birthdayyear").select_option(value: birthday.year.to_s)
      human_delay
      page.locator("#registration-form-birthdaymonth").select_option(value: format("%02d", birthday.month))
      human_delay
      page.locator("#registration-form-birthdayday").select_option(value: format("%02d", birthday.day))
      # random_scroll
      human_delay
      # 选择性别
      # page.locator('[name="dwfrm_profile_customer_gender"]').select_option(value: rand(0..2).to_s)
      human_select(page, '[name="dwfrm_profile_customer_gender"]', rand(0..2).to_s)
      human_delay

      # 填写地址
      # page.locator("#registration-form-postcode").type(address.postal_code)
      page.locator("#registration-form-postcode").type(address.postal_code, delay: rand(50..150))

      # 填写邮编后页面会触发事件，所以需要等待，否则会把填写的house_number清空
      human_delay(2.0, 5.0)
      page.wait_for_selector("#registration-form-address-line1:enabled")
      page.locator("#registration-form-address-line1").type(address.house_number, delay: rand(30..80))
      # page.locator("#registration-form-address-line1").type(address.house_number)
      human_delay
      page.locator("#registration-form-address-line2").type(address.street_address, delay: rand(50..120))
      # random_scroll
      human_delay

      # 填写手机号
      page.locator('[name="dwfrm_profile_customer_phone"]').type(phone, delay: rand(50..120))
      human_delay

      # 输入密码
      page.locator('[name="dwfrm_profile_login_password"]').type(PASSWORD, delay: rand(50..120))
      # page.locator('[name="dwfrm_profile_login_password"]').fill(PASSWORD)
      human_delay
      page.locator('[name="dwfrm_profile_login_passwordconfirm"]').type(PASSWORD, delay: rand(50..120))
      # page.locator('[name="dwfrm_profile_login_passwordconfirm"]').fill(PASSWORD)
      human_delay
      # 同意条款
      page.locator("#terms").check
      human_delay
      page.locator("#privacyPolicy").check
      # random_scroll

      # human_delay(8.0, 12.0)
      # 点击提交按钮
      # human_click("#registration_button")
      # human_click("#registration_button") do
      #   page.locator("#registration_button").click(
      #     force: true,
      #     delay: rand(30..150),
      #     noWaitAfter: true
      #   )
      # end

      # page.wait_for_selector("#registration_button", state: "visible")  # 等待按钮可见
      # page.hover("#registration_button")
      # page.click("#registration_button")

      # page.locator("#registration_button").click(force: true)
      # page.click("#registration_button")

      #   human_delay(8.0, 12.0)

      #   # 点击确认
      #   page.click("button.submitButton")

      #   # 等待注册完毕
      #   human_delay(6.0, 10.0)

      #   if page.url == "https://www.pokemoncenter-online.com/new-customer-complete/"
      #     logger.info "(#{email})注册完毕！"
      #     credit_card = CreditCard.first
      #     VirtualUser.create!(credit_card: credit_card, address: address, email: email, password: PASSWORD, mobile: phone)
      #   end
      #   sleep 10
      # ensure
      #   page.close
      #   @browser.close
      #   @playwright_exec.stop
    end

    def human_select(page, selector, value)
      select = page.locator(selector)

      # 随机延迟后点击
      page.wait_for_timeout(rand(200..800))
      select.click

      # 随机移动鼠标
      page.mouse.move(
        rand(select.bounding_box["x"]..select.bounding_box["x"] + select.bounding_box["width"]),
        rand(select.bounding_box["y"]..select.bounding_box["y"] + select.bounding_box["height"])
      )

      # 等待选项出现
      page.wait_for_timeout(rand(300..1000))

      select.select_option(value: value)
    end




    # 发送注册链接的邮件
    def send_email(register_emails)
      emails = register_emails.keys
      exist_emails = VirtualUser.where(email: emails).pluck(:email)
      (emails - exist_emails).each do |email|
        @retry_count = 0
        begin
          click_register(email)
        rescue Exception => _e
          logger.error "账号(#{email})发送注册邮件失败！"
          next
        end
        sleep rand(2.0..5.0)
      end
    ensure
      page.close
      @browser.close
      @playwright_exec.stop
    end

    def click_register(email)
      page.goto(LOGIN_URL, waitUntil: "domcontentloaded")
      human_delay
      page.locator('[name="dwfrm_profile_confirmationEmail_email"]').fill(email)
      human_delay
      page.locator("#form2Button").click
      human_delay(4.0, 6.0)
      page.locator("#send-confirmation-email").click
      human_delay(4.0, 6.0)
    rescue Exception => e
      raise e if @retry_count >= 3
      @retry_count += 1
      retry
    end

    def human_delay(min = 1.0, max = 3.0)
      sleep(rand(min..max))
    end

    def random_scroll
      scroll_times = rand(2..5)
      scroll_times.times do
        page.mouse.wheel(0, rand(200..800))
        human_delay(0.3, 1.5)
      end
    end

    class << self
      def resolve_email(manager_email, manager_password)
        result = []
        # 登陆邮箱
        imap = Net::IMAP.new("imap.exmail.qq.com", ssl: true)
        imap.login(manager_email, manager_password)
        # 进入收件箱
        imap.id(name: "IMAPClient", version: "2.1.0")
        imap.select("INBOX")
        # 将邮件倒序然后遍历
        # unseen_ids = imap.search([ "ALL" ])
        # 取未读邮件
        unseen_ids = imap.search([ "UNSEEN" ])
        unseen_ids.reverse.each do |id|
          body = imap.fetch(id, "BODY[TEXT]")[0].attr["BODY[TEXT]"]
          mail = Mail.new(body)
          # 获取邮件内容
          decoded_text = mail.decode_body.gsub(/\\x([0-9a-fA-F]{2})/) { |m| $1.hex.chr }.force_encoding("UTF-8")
          text = decoded_text.encode("UTF-8", invalid: :replace, undef: :replace)
          next unless text.include? "new-customer"
          match = text.match(/▼URL\s*\n\s*(https:\/\/www\.pokemoncenter-online\.com\/new-customer\/\?token=[^\s]+)/i)
          next unless match
          target_url = match[1].strip
          # 获取收件人信息
          envelope = imap.fetch(id, "ENVELOPE")[0].attr["ENVELOPE"]
          addr = envelope.to.first
          email = "#{addr.mailbox}@#{addr.host}"
          # BkmRegisterJob.set(wait: (rand(1.0..10.0).minutes)).perform_later(email, phone, target_url)
          # imap.uid_store(id, "+FLAGS", [ :Seen ])
          result << { email: email, link: target_url }
        end
        result
      end
    end
  end
end
