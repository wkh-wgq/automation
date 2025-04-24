module ApplicationHelper
  def company_for_select
    Company.all.map do |company|
      [ company.name, company.id ]
    end.unshift([ "请选择公司", "" ])
  end
end
