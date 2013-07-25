require 'liquid'

module AtPay
  module Button
    class Template
      #include ActionView::Helpers::NumberHelper

      # Requires destination and email in addition to this, which should just be strings...
      def initialize(options)
        @options = {
          :subject => "Submit @Pay Payment",
          :title => "Pay",
          :color => "#6dbe45",
          :image => "https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png",
          :processor => "transaction@secure.atpay.com"
        }.update(options)
      end

      def render(args)
        template.render({
          :url          => mailto,
          :outlook_url  => mailto("outlook"),
          :yahoo_url    => mailto("yahoo"),
          :content      => number_to_currency(amount),
          :dollar       => number_to_currency(amount).match(/\$\d+(?=\.)/).to_s,
          :cents        => number_to_currency(amount).match(/(?<=\.)[^.]*/).to_s,
        }.update(@options.update(args)))
      end

      private
      def mailto
        case provider
          when :outlook
            outlook_mailto
          when :yahoo
            yahoo_mailto
          when :default
            default_mailto
        end
      end

      def provider
        if ["yahoo.com", "ymail.com", "rocketmail.com"].any? { |c| c.include? @options[:email] }
          :yahoo
        elsif @options[:email] =~ /hotmail\.com$/
          :outlook
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

      def mailto_body_template
        Liquid::Template.parse(File.read(File.join(Dir.pwd, "templates/mailto_body.liquid")))
      end
  
      def mailto_body
        URI::encode(mailto_body_template.render({
          :amount => number_to_currency(amount),
          :name => destination,
          :token => @options[:token]
        }))
      end

      # This is processed as liquid - in the future we can allow overwriting the
      # template here and creating custom buttons.
      def template
        @template ||= Liquid::Template.parse(template_content)
      end

=begin
      Use provider and extend the checks there.
      def template_content
        if ["yahoo.com","ymail.com","rocketmail.com"].any? { |check| destination.email.include?(check) } && wrapper == true
          File.read(File.join(Dir.pwd, "templates/template_yahoo_wrap.liquid")).squish
        elsif ["yahoo.com","ymail.com","rocketmail.com"].any? { |check| destination.email.include?(check) } && wrapper != true 
          File.read(File.join(Dir.pwd, "templates/template_yahoo.liquid")).squish  
        elsif wrapper == true
          File.read(File.join(Dir.pwd, "templates/template_wrap.liquid")).squish
        else
          File.read(File.join(Dir.pwd, "templates/template.liquid")).squish
        end  
      end
=end
    end
  end
end
