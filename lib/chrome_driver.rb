# chrome 浏览器的 driver
class ChromeDriver < BroswerDriver
  def self.build
    options = Selenium::WebDriver::Options.chrome
    # options.page_load_strategy = :eager
    options.add_argument("--headless")
    # options.add_argument("--user-data-dir=/tmp/chrome-user-data-#{SecureRandom.hex}")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-gpu")
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.manage.timeouts.implicit_wait = 2
    driver
  end
end
