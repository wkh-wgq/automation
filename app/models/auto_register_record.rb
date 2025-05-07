class AutoRegisterRecord < ApplicationRecord
  include AASM

  belongs_to :company
  belongs_to :virtual_user
  belongs_to :address

  validates_uniqueness_of :virtual_user_id, scope: :company_id
  validates :email, presence: true, uniqueness: { scope: :company_id }
  validate :validate_account

  # 注册记录创建之后立刻发送邮件
  after_commit :send_register_email, on: :create

  aasm(:state) do
    # 待执行
    state :pending, initial: true
    # 已发送邮件，等待执行
    state :sent
    # 执行中
    state :executing
    # 执行成功
    state :successful
    # 执行失败
    state :failed

    # 发送邮件
    event :send_email do
      transitions from: :pending, to: :sent
    end

    # 执行注册
    event :execute do
      transitions from: :sent, to: :executing
    end

    # 执行成功
    event :complete, after: :create_account do
      transitions from: :executing, to: :successful
    end

    # 执行失败
    event :fail do
      transitions from: :executing, to: :failed
      transitions from: :pending, to: :failed
    end
  end

  def send_register_email
    ::Bkm::SendRegisterEmailJob.perform_later(self.id)
  end

  def to_fail(error_message)
    self.error_message = error_message
    self.fail!
  end

  def create_account
    Account.create!(
      company_id: self.company_id,
      user_id: self.virtual_user_id,
      account_no: self.email,
      address_id: self.address_id,
      password: BKM_ACCOUNT_PASSWORD
    )
  end

  def set_properties(key, value)
    self.properties ||= {}
    self.properties[key] = value
  end

  private
  def validate_account
    if self.company.accounts.of_user(self.virtual_user_id).count > 0
      errors.add(:base, "用户的账号已经存在！")
    end
    if self.company.accounts.of_account_no(self.email).count > 0
      errors.add(:base, "邮箱的账号已经存在！")
    end
  end
end
