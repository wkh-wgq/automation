# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 创建默认地址
Address.create!(postal_code: '1690075', street_address: '東京都新宿区高田馬場2-14-6  アライビル5階')
# 创建默认信用卡
CreditCard.create!(cardholder_name: 'lifangyi', card_number: '4514617600310462', expiration_date: '28-09', security_code: '405')
