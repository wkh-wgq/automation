json.extract! payment, :id, :company_id, :mode, :info, :created_at, :updated_at
json.url payment_url(payment, format: :json)
