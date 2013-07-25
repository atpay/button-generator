module AtPay
  module Button
    class Collector
      include Validation::Email
      include Validation::Amount

      SOURCES = [
        :cards,
        :emails,
        :members
      ]

      def initialize(options)
        @options = options
        user_data = options[:user_data]
        @env = options[:env]

        build_session options[:partner_id], options[:keys]

        @button = Generator.new @session, options
      end

      def user_data=(v)
        return if v.nil?

        raise Validation::LengthError.new "user_data can't be longer than 2,500 characters, you provided #{v.length} characters" if v.length > 2500

        @user_data = v
      end

      def generate
        options[:targets].each do |type, sources|
          token_type = { cards: :card, emails: :email, members: :member }[type]
          @buttons[type] = sources.collect do |source|
            [source, build(token_type, source)]
          end
        end
      end


      private

      def build(type, source)
        @button.build(type, source)
      end

      def build_session(partner_id, keys)
        @session = AtPay::Session.new({
          public_key: keys[:public],
          private_key: keys[:private],
          partner_id: partner_id,
          environment: @env
        })
      end
    end
  end
end
