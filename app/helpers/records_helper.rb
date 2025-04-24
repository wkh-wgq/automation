module RecordsHelper
  def account_for_select
    Account.all.map do |account|
      [ account.account_no, account.id ]
    end.unshift([ "请选择账号", "" ])
  end
end
