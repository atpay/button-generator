require 'spec_helper'

describe AtPay::Button::Collector do
  let(:params) { { amount: '20', targets: {cards: ['383tdjgh37'], emails: ['bob@com.com']}, partner_id: 1, keys: {public: 'bob', private: 'privatebob'}, env: :sandbox } }
  let(:subject) { AtPay::Button::Collector.new params }

  describe "#new" do
    describe "type" do
      it "defaults to payment" do
        subject.type.must_equal :payment
      end

      it "accepts validation" do
        gen = AtPay::Button::Collector.new params.merge({type: :validation})

        gen.type.must_equal :validation
      end
    end
  end

  describe "#user_data=" do
    it "doesn't allow more than 2500 characters" do
      assert_raises(AtPay::Button::Validation::LengthError) { AtPay::Button::Collector.new params.merge({user_data: ('a' * 2501)}) }
    end
  end

  describe "#build_session" do
    it "configures the session with the provided parameters" do
      AtPay::Session.expects(:new).with public_key: 'bob', private_key: 'privatebob', partner_id: 1, environment: :sandbox

      subject
    end
  end

  describe "#generate" do
    it "returns an association of buttons and the source value used to build them" do
      AtPay::Button::Generator.any_instance.expects(:build).returns('button')

      subject.generate.must_equal [['383tdjgh37', 'button'], ['bob@com.com', 'button']]
    end
  end
end
