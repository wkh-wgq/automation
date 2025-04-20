class Company < ApplicationRecord
  has_many :accounts
  has_many :addresses
  has_many :payments

  validates_presence_of :name, :code
  validates_uniqueness_of :name, :code
end
