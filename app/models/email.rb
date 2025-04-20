class Email < ApplicationRecord
  with_options foreign_key: :parent_id, class_name: "Email" do
    has_many :children, dependent: :destroy
    belongs_to :parent, optional: true
  end

  has_many :accounts, foreign_key: :account_no, primary_key: :email

  validates_presence_of :email
  validates_presence_of :domain, if: :is_primary?
  validates_uniqueness_of :email

  scope :of_primary, -> () {
    where(parent_id: nil)
  }

  def is_primary?
    self.parent_id.blank?
  end
end
