# == 信用卡信息
#
#  cardholder_name :string  持卡人姓名
#  card_number     :string  卡号
#  expiration_date :string  有效期('28-07')，只要年和月
#  security_code   :string  安全码
#
class CreditCard < ApplicationRecord
end
