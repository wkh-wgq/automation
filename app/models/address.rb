# @attr[String] company_id
# @attr[Hash] detail
#   bkm的地址格式：{
#     postal_code: '1690075',     # 邮编
#     street_number: '2-14-6',    # 门牌号
#     address: 'アライビル５階'     # 地址
#   }
#
class Address < ApplicationRecord
  belongs_to :company
  has_many :accounts
end
