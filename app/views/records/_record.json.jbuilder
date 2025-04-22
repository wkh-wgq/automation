json.extract! record, :id, :plan_id, :account_id, :state, :failed_step, :error_message, :created_at, :updated_at
json.url record_url(record, format: :json)
