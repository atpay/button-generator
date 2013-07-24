module AtPay
  module Button
    module EmailValidation
      def self.included(base)
        base.class_eval do
          validate :validate_email
        end
      end

      def validate_email
        if email.blank? or email.empty?
          errors[:email] << "not present"
          return
        end

        email.each do |e|
          errors[:email] << "'#{e}' not valid" unless e =~ /^.+@.+$/
        end
      end
    end
  end
end
