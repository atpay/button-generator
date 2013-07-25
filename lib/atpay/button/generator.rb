module AtPay
  module Button
    class Generator
      include Validation::Email
      include Validation::Amount

      SOURCES = [
        :cards,
        :emails,
        :members
      ]

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
        #self.email = options[:email]
        self.owner = options[:owner]
        self.wrapper = options[:wrapper]
        self.image = options[:image]
        self.color = options[:color]
        self.type = options[:type]
        self.user_data = options[:user_data]

        @env = options[:env]

        set_targets options[:targets]
        build_session options[:partner_id], options[:keys]

        @member_map = {}
      end

      def amount=(v)        
        unless v.nil? or v.empty?
          @amount = v.to_s.gsub(/[^0-9\.]/, "").to_f 
        else
          @amount = v
        end

        validate_amount
      end

      def email=(v)
        @email = (v || "").split(/\n|\r|,/).collect(&:strip).select { |e| 
          !e.strip.blank?
        }

        validate_email
      end

      # Default to payment buttons.
      def type=(v)
        @type = v ? v.to_sym : :payment
      end

      def member_button(key_uuid)
        Template.new.tap { |button|
          button.security_key_uuid = key_uuid
          button.amount = amount
          button.wrapper = wrapper
          button.image = image
          button.color = color

          button.destination = Template.new
          button.destination.email = email
          button.destination.amount = amount
          button.destination.wrapper = wrapper
          button.destination.image = image
          button.destination.color = color
          button.destination.default_partner_uuid = owner
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

        @buttons ||= mailto_buttons
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

      def tokens
        build_security_keys

        @tokens ||= mailto_tokens + link_tokens
      end

      private

      def set_targets(targets)
        (targets.keys & SOURCES).each do |type|
          instance_variable_set('@' + type.to_s, targets[type])
        end
      end

      def build_session(partner_id, keys)
        @session = AtPay::Session.new({
          public_key: keys[:public],
          private_key: keys[:private],
          partner_id: partner_id,
          environment: @env
        })
      end

      def generate_tokens(source = nil)
        @tokens = {}

        if source
          ((source.respond_to?(:each) ? source : [source]) & SOURCES).each do |source|
            @tokens[source] = tokens_for(source) if instance_variable_get('@' + source.to_s)
          end
        else
          SOURCES.each do |source|
            @tokens[source] = tokens_for(source) if instance_variable_get('@' + source.to_s)
          end
        end
      end

      def tokens_for(source_type)
        targets = instance_variable_get("@" + source_type.to_s)

        # There is a horrible line below.  It really should be cleaned up ASAP
        targets.inject([]) do |collection, target|
          [
            target,
            @session.security_key({
              amount: amount,
              source_type.to_s.chop.to_sym => target,
              group: group
            }).email_token
          ]
        end
      end

      def build_security_keys
        return if members.nil? or members.empty?

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
  end
end
