module AtPay
  module Button
    module Validation
      module Amount
        def validate_amount
          if amount.nil?
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
