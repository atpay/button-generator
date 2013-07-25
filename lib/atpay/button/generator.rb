module AtPay
  module Button
    class Generator
      SOURCES = [
        :cards,
        :emails,
        :members
      ]

      def initialize(session, options)
        @session = session

        @options = { 
          :title => "Pay",
          :type => :payment,
          :group => nil,
          :user_data => nil
        }.update options

        template
      end

      def email
        @options[:email]
      end

      def amount
        @amount ||= @options[:amount].gsub(/[^0-9\.]/, "").to_f
      rescue
        nil
      end

      def token(type, source)
        @session.security_key(@options.merge({type => source})).email_token
      end

      def template
        @template ||= Template.new(@options[:template])
      end

      def to_html(token)
        @template.render(:token => token)
      end

      def build(type, source)
        to_html token(type, source)
      end
    end
  end
end
