# == 虚拟用户
#
#  email          :string   登陆邮箱
#  password       :string   邮箱登陆密码
#  address_id     :integer  地址
#  credit_card_id :integer  信用卡
#
class VirtualUser < ApplicationRecord
  belongs_to :address
  belongs_to :credit_card
end
