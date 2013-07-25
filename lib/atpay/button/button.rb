module AtPay
  module Button
    class Button
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
      end

      def email
        @options[:email]
      end

      def amount
        @amount ||= @options[:amount].gsub(/[^0-9\.]/, "").to_f
      rescue
        nil
      end

      def tokens
        [*@session.security_key(@options)].collect { |t| t.email_token }
      end

      def template
        @template ||= Template.new(self, @options[:template])
      end

      def to_html
        tokens.collect { |t| @template.render(:token => t) }
      end
    end
  end
end
