# 抢单计划的执行记录
class Record < ApplicationRecord
  belongs_to :plan
  belongs_to :virtual_user
end
