module RecordsHelper
  def account_for_select
    Account.all.map do |account|
      [ account.account_no, account.id ]
    end.unshift([ "请选择账号", "" ])
  end

  def format_state(state)
    case state
    when "pending"
      "待执行"
    when "executing"
      "执行中"
    when "failed"
      "执行失败"
    when "completed"
      "执行完成"
    else
      "未知状态"
    end
  end
end
