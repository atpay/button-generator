module AtPay
  module Button
    class LengthError < Exception
    end

    class Generator
      # TODO:  This should really move to the underlying token library.
      TOKEN_TYPES = {
        payment: nil,
        validation: 1
      }

      def initialize(options)
        @options = { 
          :title => "Pay",
          :type => :payment,
          :group => nil,
          :user_data => nil,
          :template => {}
        }.update options

        @options[:version] = TOKEN_TYPES[@options[:type]] if TOKEN_TYPES[@options[:type]]

        validate_user_data
        @options[:amount] = amount
      end

      def amount
        @amount ||= @options[:amount].respond_to?(:gsub) ? @options[:amount].gsub(/[^0-9\.]/, "").to_f : @options[:amount]
      end

      # Custom data that is to be added to the token can't exceed 2,500 characters.
      def validate_user_data
        return unless @options[:user_data]

        raise LengthError.new "user_data can't be longer than 2,500 characters, you provided #{@options[:user_data].length} characters" if @options[:user_data].length > 2500
      end

      # Builds an @Pay Payment token for injection into a mailto button.
      #
      # @param type [Symbol] The button type: :email, :card, :member
      # @param source [String] The coresponding type value
      #
      # @return [String]
      def token(type, source)
        session.security_key(@options.merge({type => source})).email_token
      end

      # Instanciate a button template instance for a specific email address.  The email is necessary
      # for selecting the correct template files.  There are some special cases depending on the
      # environment that the button is being viewed in.
      #
      # @param email [String] the email address the button is intended for.
      #
      # @return [AtPay::Button::Template]
      def template(email)
        Template.new(@options.update(:email => email, :amount => amount))
      end

      def to_html(token, email)
        template(email).render(token: token, email: email)
      end

      # Generate the actual button HTML.  There are three options available :source (the card token),
      # :email (the email address the button is intended for), :type (the type of the source identifier)
      # :type defaults to card.
      #
      # @param options [Hash] there are three options that matter: :source, :email and :type
      #
      # @return [String]
      def generate(options)
        options[:source] ? source = options[:source] : source = options[:email]
        options[:type] ? type = options[:type] : type = :card
        email = options[:email]

        to_html token(type, source), email
      end

      # Build buttons for the provided collection.  build will accept an array of email addresses ['bob@bob', 'sue@sue'], 
      # or any "paired" collection:  For example [['bob@bob', 'card_token'], ['sue@sue', 'card_token']] will work,
      # as will 'bob@bob' => 'card_token', 'sue@sue' => 'card_token'.  If providing only a list of email
      # addresses build will create email tokens.  Only use this behavior if you are sure it is what both you
      # and your customer want.  An email token isn't ultra-specific about the card it charges.  It will charge
      # the first card for that individual it finds that your @Pay account has permission to use.
      #
      # @param token_map [Enumerable]
      #
      # @return [Array] a list of tuples containing the email address and button code as [String]s
      def build(token_map)
        token_map.collect do |email, card|
          card ? [email, generate(email: email, source: card)] : [email, generate(email: email, type: :email)]
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
