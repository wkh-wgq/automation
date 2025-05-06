Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  # 账户
  resources :accounts
  # 支付
  resources :payments
  # 地址
  resources :addresses
  # 公司
  resources :companies
  # 邮箱
  resources :emails do
    resources :child_emails, shallow: true
  end
  # 虚拟用户
  resources :virtual_users, shallow: true do
    # 自动注册记录
    resources :auto_register_records
  end
  # 计划
  resources :plans, shallow: true do
    # 执行步骤
    resources :execute_steps
    # 执行记录
    resources :records do
      member do
        put :execute
      end
    end
  end
end
