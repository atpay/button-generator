module AtPay
  module Button
    module Validation
      module Email
        def validate_email
          if email.nil? or email.empty?
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
