require 'active_support'

class ButtonTemplate
  attr_accessor :destination,
    :amount,
    :email,
    :security_key_uuid,
    :button_title,
    :button_content,
    :mailto_subject,
    :mailto_body,
    :wrapper,
    :color,
    :image
  
  def to_html
    @html ||= template.render({
      "url" => (security_key_uuid ? mailto : signup_url),
      "outlook_url" => (security_key_uuid ? mailto("outlook") : signup_url),
      "yahoo_url" => (security_key_uuid ? mailto("yahoo") : signup_url),
      "title" => "Pay",
      "content" => ActionController::Base.helpers.number_to_currency(amount),
      "dollar" =>  ActionController::Base.helpers.number_to_currency(amount).match(/\$\d+(?=\.)/).to_s,
      "cents" =>   ActionController::Base.helpers.number_to_currency(amount).match(/(?<=\.)[^.]*/).to_s,
      "color" => color || "#6dbe45",
      "image" => image || "https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png",   
      "title" => button_title || "Pay",
      "content" => button_content || ActionController::Base.helpers.number_to_currency(amount)
    })
  end

  def signup_url
    "https://atpay.com/pay_pages/#{destination.default_partner_uuid}/registrations/new?transaction[amount]=#{amount}"
  end

  def payment_url
    "https://atpay.com/pay_pages/#{destination.default_partner_uuid}/transactions/new?transaction[amount]=#{amount}&security_key_uuid=#{security_key_uuid}"
  end

  def url
    if security_key_uuid
      payment_url
    else
      signup_url
    end
  end

  def mail_target
    "transaction@secure.atpay.com"
  end

  def mailto(email_type = "normal") 
    target = mail_target #TODO transaction_email_address config
    subject = mailto_subject || I18n.t("button.mailto.subject", :default => "Submit @Pay Payment")
    body = mailto_body  
    
    case email_type
    when'yahoo'
      "http://compose.mail.yahoo.com/?to=#{target}&subject=#{URI::encode(subject.to_str)}&body=#{URI::encode(body.to_str)}"    
    when'outlook'
      "https://www.hotmail.com/secure/start?action=compose&to=#{target}&subject=#{URI::encode(subject.to_str)}&body=#{URI::encode(body.to_str)}"
    else
      "mailto:#{target}?subject=#{URI::encode(subject.to_str)}&body=#{URI::encode(body.to_str)}"
    end  
  end

  def mailto_body
    I18n.t("button.mailto.body", 
      :default => "Please press send to complete your transaction. Thank you for your payment of %{amount} to %{name}. Your receipt will be emailed to you shortly. Here is the ID code that will expedite your transaction %{key}",
      :amount => ActionController::Base.helpers.number_to_currency(amount),
      :name => destination.default_partner_name,
      :key => security_key_uuid)
  end

  # This is processed as liquid - in the future we can allow overwriting the
  # template here and creating custom buttons.
  def template
    @template ||= Liquid::Template.parse(template_content)
  end

  def template_content
    if ["yahoo.com","ymail.com","rocketmail.com"].any? { |check| destination.email.include?(check) } && wrapper == true
      File.read(File.join(Rails.root, "app/views/api/buttons/template_yahoo_wrap.liquid")).squish
    elsif ["yahoo.com","ymail.com","rocketmail.com"].any? { |check| destination.email.include?(check) } && wrapper != true 
      File.read(File.join(Rails.root, "app/views/api/buttons/template_yahoo.liquid")).squish  
    elsif wrapper == true
      File.read(File.join(Rails.root, "app/views/api/buttons/template_wrap.liquid")).squish
    else
      File.read(File.join(Rails.root, "app/views/api/buttons/template.liquid")).squish
    end  
  end
end
