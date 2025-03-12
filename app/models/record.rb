class Record < ApplicationRecord
  belongs_to :plan
  belongs_to :virtual_user
end
