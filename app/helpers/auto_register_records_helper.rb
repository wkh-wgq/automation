module AutoRegisterRecordsHelper
  def address_for_select
    Address.all.map do |address|
      [ "#{address.detail['street_number']}-#{address.detail['address']}", address.id ]
    end.unshift([ "请选择地址", "" ])
  end

  def format_state(state)
    case state
    when "pending"
      "待执行"
    when "sent"
      "已发送邮件"
    when "executing"
      "执行中"
    when "failed"
      "执行失败"
    when "completed"
      "执行成功"
    else
      "未知状态"
    end
  end
end
