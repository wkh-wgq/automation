json.extract! virtual_user, :id, :first_name, :last_name, :gender, :birthday, :mobile, :created_at, :updated_at
json.url virtual_user_url(virtual_user, format: :json)
