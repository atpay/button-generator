require 'spec_helper'

describe AtPay::Button::Generator do
  let(:params) { { amount: '20', targets: {cards: ['383tdjgh37']}, destination: 1, keys: {public: '', private: ''}, env: :sandbox } }
  let(:subject) { AtPay::Button::Generator.new params }

  describe "#new" do
    it "configures the token session"

    it "sets the amount"

    it "sets the targets"

    it "sets the wrapper"

    it "sets the image"

    it "sets the color"

    describe "type" do
      it "defaults to payment"

      it "accepts validation"
    end

    it "sets the user data"

    it "runs the validations"
  end

  describe "#build_session" do
    it "configures the session with the provided parameters" do
      AtPay::Session.expects(:new).with public_key: 'bob', private_key: 'privatebob', partner_id: 1, environment: :sandbox

      subject
    end
  end

  describe "#generate" do
    
  end
end