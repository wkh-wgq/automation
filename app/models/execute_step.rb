#
# == 执行的步骤
# @attr[String] type          类型(system 系统内设/custom 自定义)
# @attr[String] element       定位的元素
# @attr[String] action        执行的动作(system: login/queue_up/human_delay;custom: click/goto/select/check/sleep)
# @attr[String] action_value  action的value(action是goto和sleep的时候需要填写值)
#
class ExecuteStep < ApplicationRecord
  belongs_to :plan
  self.inheritance_column = :not_need

  validates_presence_of :type, :action
  validates :type, inclusion: { in: %w[system custom] }
  validates :action, inclusion: { in: %w[login queue_up human_delay] }, if: :system?
  validates :action, inclusion: { in: %w[click goto select check sleep] }, if: :cutom?
  validates :action_value, presence: true, if: :need_action_value?

  def system?
    self.type == "system"
  end

  def cutom?
    !system?
  end

  def need_action_value?
    %w[goto sleep].include? self.action
  end
end
