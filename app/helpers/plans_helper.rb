module PlansHelper
  def type_for_select
    [
      [ "选择步骤类型", "" ],
      [ "系统内置", "system" ],
      [ "自定义", "custom" ]
    ]
  end

  def action_for_select
    [
      [ "请先选择步骤类型", "" ],
      [ "login", "login" ],
      [ "queue_up", "queue_up" ],
      [ "human_delay", "human_delay" ],
      [ "click", "click" ],
      [ "goto", "goto" ],
      [ "check", "check" ],
      [ "sleep", "sleep" ]
    ]
    # case type
    # when "system"
    #   [
    #     [ "login", "login" ],
    #     [ "queue_up", "queue_up" ],
    #     [ "human_delay", "human_delay" ]
    #   ]
    # when "custom"
    #   [
    #     [ "click", "click" ],
    #     [ "goto", "goto" ],
    #     [ "check", "check" ],
    #     [ "sleep", "sleep" ]
    #   ]
    # else
    #   [ [ "请先选择步骤类型", "" ] ]
    # end
  end
end
