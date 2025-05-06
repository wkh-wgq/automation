class VirtualUser < ApplicationRecord
  has_many :accounts, foreign_key: :user_id, dependent: :destroy
  has_many :auto_register_records

  validates_presence_of :first_name, :last_name, :mobile, :birthday, :gender
  validates_uniqueness_of :mobile

  scope :search, ->(keywords) {
    where("(last_name || first_name) LIKE ?", "%#{keywords}%")
  }

  scope :by_mobile, ->(mobile) {
    where(mobile: mobile)
  }

  def name
    self.last_name + self.first_name
  end
end
