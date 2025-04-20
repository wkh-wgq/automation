json.extract! email, :id, :email, :parent, :domain, :imap_password, :mobile, :created_at, :updated_at
json.url email_url(email, format: :json)
