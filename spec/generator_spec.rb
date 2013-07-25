require 'spec_helper'

describe AtPay::Button::Generator do
  let(:params) { { amount: '20', targets: {cards: ['383tdjgh37'], emails: ['bob@com.com']}, partner_id: 1, keys: {public: 'bob', private: 'privatebob'}, env: :sandbox } }
  let(:subject) { AtPay::Button::Generator.new params }

  describe "#new" do
    describe "type" do
      it "defaults to payment" do
        subject.type.must_equal :payment
      end

      it "accepts validation" do
        gen = AtPay::Button::Generator.new params.merge({type: :validation})

        gen.type.must_equal :validation
      end
    end

    it "sets the user data"

    it "runs the validations"
  end

  describe "#set_targets" do
    it "assigns the given values to instance variables" do
      subject.instance_eval { @cards }.must_equal ['383tdjgh37']
      subject.instance_eval { @emails }.must_equal ['bob@com.com']
      subject.instance_eval { @members }.must_be :nil?
    end
  end

  describe "#build_session" do
    it "configures the session with the provided parameters" do
      AtPay::Session.expects(:new).with public_key: 'bob', private_key: 'privatebob', partner_id: 1, environment: :sandbox

      subject
    end
  end

  describe "#generate_tokens" do
    before do
      @dummy_session = mock
      AtPay::Session.stubs(:new).returns(@dummy_session)
    end

    it "generates tokens for all target types if none specified" do
      @dummy_session.expects(:security_key).with(any_parameters) { |options| options.has_key? :emails }
      @dummy_session.expects(:security_key).with(any_parameters) { |options| options.has_key? :cards }

      subject.send :generate_tokens

      subject.targets.keys.must_include :cards
      subject.targets.keys.must_include :emails
      subject.targets.keys.wont_include :members
    end

    it "generates tokens for only the specified target type" do
      subject.send(:generate_tokens, :cards)

      subject.targets.keys.must_equal [:cards]
    end
  end

  describe "#generate" do
    
  end
end
