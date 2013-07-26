module AtPay
  module Button
    class LengthError < Exception
    end

    class Generator
      def initialize(options)
        @options = { 
          :title => "Pay",
          :type => :payment,
          :group => nil,
          :user_data => nil,
          :template => {}
        }.update options

        validate_user_data
        @options[:amount] = amount

        template
      end

      def amount
        @amount ||= @options[:amount].respond_to?(:gsub) ? @options[:amount].gsub(/[^0-9\.]/, "").to_f : @options[:amount]
      end

      def validate_user_data
        return unless @options[:user_data]

        raise LengthError.new "user_data can't be longer than 2,500 characters, you provided #{@options[:user_data].length} characters" if @options[:user_data].length > 2500
      end

      def token(type, source)
        session.security_key(@options.merge({type => source})).email_token
      end

      def template
        @template ||= Template.new(@options.update(:email => @options[:email], :amount => amount))
      end

      def to_html(token, email)
        @template.render(:token => token, email: email)
      end

      def generate(options)
        options[:source] ? source = options[:source] : source = options[:email]
        options[:type] ? type = options[:type] : type = :card
        email = options[:email]

        to_html token(type, source), email
      end

      def build(token_map)
        token_map.collect do |email, card|
          [email, generate(email: email, source: card)]
        end
      end


      private

      def session
        @session ||= AtPay::Session.new({
          public_key: @options[:public_key],
          private_key: @options[:private_key],
          partner_id: @options[:partner_id],
          environment: @options[:env]
        })
      end
    end
  end
end
