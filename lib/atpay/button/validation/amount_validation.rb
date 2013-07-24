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
              errors[:amount] << "not present"
              return
            end

            if BigDecimal.new(amount.to_s).round(2).to_f != amount.to_f
              errors[:amount] << "cannot split cents"
            end

            if amount.to_f > 250
              errors[:amount] << "cannot exceed $250.00"
            end

            if amount.to_f < 5
              errors[:amount] << "cannot be below $5.00"
            end
          end
        end
      end
    end
  end
end
