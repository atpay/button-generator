module AtPay
  module Button
    module Validation
      class MissingAmount < ArgumentError; end

      class SplittingCents < ArgumentError; end

      class MissingEmail < ArgumentError; end

      class InvalidEmail < ArgumentError; end

      class LengthError < ArgumentError; end
    end
  end
end