json.extract! account, :id, :account_no, :company_id, :user_id, :address_id, :payment_id, :password, :last_login_time, :created_at, :updated_at
json.url account_url(account, format: :json)
