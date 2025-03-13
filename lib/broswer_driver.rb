class BroswerDriver
  # 生成浏览器的驱动对象
  def self.build(&block)
    type = self.name.gsub("Driver", "").underscore.to_sym
    raise "请选择正确的浏览器" if type == :broswer
    options = generate_options(type, &block)
    driver = Selenium::WebDriver.for type, options: options
    # 隐式等待时间(s)，作用是在driver查找元素时，如果没有立即找到，会等待一段时间，直到元素出现或者超时
    driver.manage.timeouts.implicit_wait = 20
    driver
  end

  private
  def self.generate_options(type)
    options = Selenium::WebDriver::Options.send(type)
    # 启用无头模式，在无头模式下，浏览器不会显示图形界面，而是在后台运行
    options.add_argument("--headless")
    # 禁用 GPU 加速
    options.add_argument("--disable-gpu")
    yield(options) if block_given?
    options
  end
end
