class Payment < ApplicationRecord
  belongs_to :company
  has_many :accounts
end
