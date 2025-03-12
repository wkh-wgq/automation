json.extract! record, :id, :plan_id, :virtual_user_id, :order_no, :failed_step, :error_message, :created_at, :updated_at
json.url record_url(record, format: :json)
