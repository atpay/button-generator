require 'activemodel'
require 'email_validation'
require 'amount_validation'

# Accepts a list of email addresses and an amount,
# creates buttons and returns json
module ButtonGenerator
  include ActiveModel::Validations
  include EmailValidation
  include AmountValidation

  attr_accessor :amount, 
    :email, 
    :owner, 
    :members, 
    :prospects,
    :group,
    :wrapper,
    :image,
    :color,
    :type,
    :user_data

  def initialize(options)
    self.amount = options[:amount]
    self.email = options[:email]
    self.owner = options[:owner]
    self.wrapper = options[:wrapper]
    self.image = options[:image]
    self.color = options[:color]
    self.type = options[:type]
    self.user_data = options[:user_data]

    @member_map = {}
  end

  def amount=(v)
    unless v.blank?
      @amount = v.to_s.gsub(/[^0-9\.]/, "").to_f 
    else
      @amount = v
    end
  end

  def email=(v)
    @email = (v || "").split(/\n|\r|,/).collect(&:strip).select { |e| 
      !e.strip.blank?
    }
  end

  # Default to payment buttons.
  def type=(v)
    @type = v ? v.to_sym : :payment
  end

  def prospect_button
    @prospect_button ||= Button.new.tap { |button|
      button.destination = owner
      button.amount = amount
      button.wrapper = wrapper
      button.image = image
      button.color = color
    }
  end

  def member_button(key_uuid)
    Button.new.tap { |button|
      button.security_key_uuid = key_uuid
      button.destination = owner
      button.amount = amount
      button.wrapper = wrapper
      button.image = image
      button.color = color
    }
  end

  def mailto_buttons
    @member_map.collect do |email, key_uuid|
      {
        :email => email,
        :amount => amount,
        :button => member_button(key_uuid).to_html
      }
    end
  end

  def link_buttons
    @prospects.collect do |email|
      {
        :email => email,
        :amount => amount,
        :button => prospect_button.to_html
      }
    end
  end

  def buttons
    type == :payment ? payment_buttons : validation_buttons
  end

  def validation_buttons
    generator = TokenGenerator.new type: :validation, amount: amount, email: email.join(','), owner: owner, user_data: user_data

    @buttons ||= generator.validation_tokens.collect do |email, token|
      {
        email: email,
        amount: amount,
        button: member_button(token).to_html
      }
    end
  end

  def payment_buttons
    build_security_keys

    @buttons ||= mailto_buttons + link_buttons
  end

  def mailto_tokens
    @member_map.collect do |email, key_uuid|
      {
        :email => email,
        :amount => amount,
        :token => key_uuid,
        :url => member_button(key_uuid).url
      }
    end
  end

  def link_tokens
    @prospects.collect do |email|
      {
        :email => email,
        :amount => amount,
        :token => nil,
        :url => prospect_button.url
      } 
    end
  end

  def tokens
    build_security_keys

    @tokens ||= mailto_tokens + link_tokens
  end

  private

  def build_security_keys
    return if members.blank?

    partner = owner.partner

    session = AtPay::Session.new({
      :public_key => Base64.encode64(partner.key_public),
      :private_key => Base64.encode64(partner.key_private),
      :partner_id => partner.partner_id,
      :environment => (Rails.env == "production" ? :production : :sandbox)
    })

    members.each do |member|
      @member_map[member.uuid] = session.security_key({
        :amount => amount, 
        :email => member.email, 
        :group => group
      }).email_token
    end
  end
end
