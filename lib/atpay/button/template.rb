require 'liquid'
require 'active_support/number_helper'
require 'uri'

module AtPay
  module Button
    class Template
      include ActiveSupport::NumberHelper

      # Requires destination and email in addition to this, which should just be strings...
      def initialize(options)
        @options = {
          :subject => "Submit @Pay Payment",
          :title => "Pay",
          :color => "#6dbe45",
          :image => "https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png",
          :processor => "transaction@secure.atpay.com",
          :templates => File.join(File.dirname(__FILE__), "/templates"),
          :wrap => false
        }.update(options)
      end

      def render(args={})
        template.render({
          'url'          => default_mailto,
          'outlook_url'  => outlook_mailto,
          'yahoo_url'    => yahoo_mailto,
          'content'      => amount,
          'dollar'       => amount.match(/\$\d+(?=\.)/).to_s,
          'cents'        => amount.match(/(?<=\.)[^.]*/).to_s,
        }.update(@options.update(args)))
      end

      private
      def amount
        number_to_currency(@options[:amount])
      end

      def provider
        if ["yahoo.com", "ymail.com", "rocketmail.com"].any? { |c| @options[:email].include? c }
          :yahoo
        else
          :default
        end 
      end

      def mailto_subject
        URI::encode(@options[:subject])
      end

      def yahoo_mailto
        "http://compose.mail.yahoo.com/?to=#{@options[:processor]}&subject=#{mailto_subject}&body=#{mailto_body}"    
      end

      def outlook_mailto
        "https://www.hotmail.com/secure/start?action=compose&to=#{@options[:processor]}&subject=#{mailto_subject}&body=#{mailto_body}"
      end

      def default_mailto
        "mailto:#{@options[:processor]}?subject=#{mailto_subject}&body=#{mailto_body}"
      end

      # Load the mailto body template from the specified location
      def mailto_body_template
        Liquid::Template.parse(File.read(File.join(@options[:templates], "mailto_body.liquid")))
      end
  
      # Parse the mailto body, this is where we inject the token, name and amount values we received in
      # the options.
      #
      # @return [String]
      def mailto_body
        URI::encode(mailto_body_template.render({
          'amount' => amount,
          'name' => @options[:destination],
          'token' => @options[:token]
        }))
      end

      # This is processed as liquid - in the future we can allow overwriting the
      # template here and creating custom buttons.
      def template
        Liquid::Template.parse(template_content)
      end

      # Determine which template to load based on the domain of the email address.
      # This preserves the mailto behavior across email environments.
      def template_content
        wrap_prefix = @options[:wrap] ? "wrap_" : ""

        case provider
          when :yahoo
            File.read(File.join(@options[:templates], "#{wrap_prefix}yahoo.liquid"))
          when :default
            File.read(File.join(@options[:templates], "#{wrap_prefix}default.liquid"))
        end
      end
    end
  end
end
