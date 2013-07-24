module AtPay
  module Button
    module Validation
      class MissingAmount < ArgumentError; end

      class SplittingCents < ArgumentError; end

      class MaxAmountExceeded < ArgumentError; end

      class MinAmountExceeded < ArgumentError; end

      class EmailMissing < ArgumentError; end

      class EmailInvalid < ArgumentError; end
    end
  end
end