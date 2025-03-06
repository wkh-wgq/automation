# microsoft-edge 浏览器的 driver
class EdgeDriver < BroswerDriver
  # driver.get "http://host.docker.internal:3000"

  # driver.find_element(:id, "user_email").send_keys("16621142402@163.com")
  # driver.find_element(:id, "user_password").send_keys("1234qwer")
  # driver.find_element(:name, "button").click

  # driver.find_element(:link_text, "Jobs").click

  # driver.find_element(:link_text, "Post a new job").click
  # driver.find_element(:id, "job_title").send_keys("selenium test")
  # driver.find_element(:id, "job_description").send_keys("selenium description")
  # driver.find_element(:id, "job_location").send_keys("shanghai")
  # driver.find_element(:name, "commit").click
  #
  def self.build
    options = Selenium::WebDriver::Options.edge
    # 等待dom加载完成，但不会等待其他资源(图片，css，js)加载完成
    options.page_load_strategy = :eager
    # 启用无头模式，在无头模式下，浏览器不会显示图形界面，而是在后台运行
    options.add_argument("--headless")
    # 禁用 GPU 加速
    options.add_argument("--disable-gpu")
    driver = Selenium::WebDriver.for :edge, options: options
    # 隐式等待时间(s)，作用是在driver查找元素时，如果没有立即找到，会等待一段时间，直到元素出现或者超时
    driver.manage.timeouts.implicit_wait = 2
    driver
  end
end
