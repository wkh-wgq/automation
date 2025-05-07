class BkmRegisterMailbox < ApplicationMailbox
  # 接收宝可梦注册邮件，并提取其中的注册链接进行注册
  def process
    decoded_text = mail.body.decoded.gsub(/\\x([0-9a-fA-F]{2})/) { |m| $1.hex.chr }.force_encoding("UTF-8")
    text = decoded_text.encode("UTF-8", invalid: :replace, undef: :replace)
    return logger.warn "不是注册邮件，忽略处理！" unless text.include? "new-customer"
    match = text.match(/▼URL\s*\n\s*(https:\/\/www\.pokemoncenter-online\.com\/new-customer\/\?token=[^\s]+)/i)
    return logger.warn "邮件中没有找到注册链接！" unless match
    target_url = match[1].strip
    email = mail.to[0]
    logger.info "收到(#{email})的bkm注册邮件,注册链接:#{target_url}"
    company = Company.find_by_code("bkm")
    return logger.warn "缺少company数据" if company.blank?
    record = AutoRegisterRecord.where(company: company, email: email).first
    reutrn logger.warn "缺少auto_register_record记录" if record.blank?
    record.set_properties("register_link", target_url)
    record.save!
    Bkm::AutoRegisterJob.perform_later(record.id)
  end
end
