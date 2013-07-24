module AtPay
  module Button
    module Validation
      module Email
        def self.included(base)
          base.class_eval do
            validate :validate_email
          end
        end

        def validate_email
          if email.blank? or email.empty?
            raise MissingEmail.new "Email not present"
            return
          end

          email.each do |e|
            raise InvalidEmal.new("'#{e}' not valid") unless e =~ /^.+@.+$/
          end
        end
      end
    end
  end
end
