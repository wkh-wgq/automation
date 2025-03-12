class VirtualUser < ApplicationRecord
  belongs_to :address
  belongs_to :credit_card
end
