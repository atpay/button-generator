module AtPay
  module Button
    module Validation
      module Amount
        def self.included(base)
          base.class_eval do
            validate :validate_amount
          end

          def validate_amount
            if amount.blank?
              raise MissingAmount.new "not present"
              return
            end

            if BigDecimal.new(amount.to_s).round(2).to_f != amount.to_f
              raise SplittingCents.new "cannot split cents"
            end
          end
        end
      end
    end
  end
end
