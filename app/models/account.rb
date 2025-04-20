class Account < ApplicationRecord
  belongs_to :company
  belongs_to :user, class_name: "VirtualUser"
  belongs_to :address, optional: true
  belongs_to :payment, optional: true

  validates_uniqueness_of :account_no, scope: :company_id

  scope :search, ->(keywords) {
    where("account_no LIKE ?", "%#{keywords}%")
  }

  scope :by_company, ->(company_id) {
    where(company_id: company_id)
  }
end
