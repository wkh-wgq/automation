class AutoRegisterRecord < ApplicationRecord
  include AASM

  belongs_to :company
  belongs_to :virtual_user
  belongs_to :address

  validates_uniqueness_of :virtual_user_id, scope: :company_id
  validates :email, presence: true, uniqueness: { scope: :company_id }

  after_commit :execute_auto_register, on: :create

  aasm(:state) do
    # 待执行
    state :pending, initial: true
    # 执行中
    state :executing
    # 执行成功
    state :successful
    # 执行失败
    state :failed

    event :execute do
      transitions from: :pending, to: :executing
      transitions from: :failed, to: :executing
    end

    # 执行成功
    event :complete do
      transitions from: :executing, to: :successful
    end

    # 执行失败
    event :fail do
      transitions from: :executing, to: :failed
    end
  end

  def execute_auto_register
  end
end
