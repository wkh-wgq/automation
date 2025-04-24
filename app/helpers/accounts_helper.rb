module AccountsHelper
  def email_for_select
    Email.all.map do |email|
      [ email.email, email.email ]
    end.unshift([ "请选择邮箱", "" ])
  end

  def virtual_user_for_select
    VirtualUser.all.map do |user|
      [ "#{user.name}-#{user.mobile}", user.id ]
    end.unshift([ "请选择用户", "" ])
  end
end
