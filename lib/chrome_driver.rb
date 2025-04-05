# chrome 浏览器的 driver
class ChromeDriver < BroswerDriver
  def self.build
    super do |options|
      # 等待dom加载完成，但不会等待其他资源(图片，css，js)加载完成
      options.page_load_strategy = :eager
    end
  end
end
