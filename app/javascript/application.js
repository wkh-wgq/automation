// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"

// 初始化所有 tooltips
document.addEventListener("turbo:load", () => {
  // console.log("Initializing tooltips..."); // 添加调试日志
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  // console.log("Found tooltips:", tooltipTriggerList.length); // 添加调试日志
  tooltipTriggerList.forEach(tooltipTriggerEl => {
    new bootstrap.Tooltip(tooltipTriggerEl, {
      placement: 'top',
      trigger: 'hover'
    })
  })
})
