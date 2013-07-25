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
      @dummy_key = mock
      @dummy_key.stubs(:email_token).returns 'token'
      AtPay::Session.stubs(:new).returns(@dummy_session)
    end

    it "generates tokens for all target types if none specified" do
      @dummy_session.expects(:security_key).with(any_parameters) { |options| options.has_key? :email }.returns(@dummy_key)
      @dummy_session.expects(:security_key).with(any_parameters) { |options| options.has_key? :card }.returns(@dummy_key)

      subject.send :generate_tokens

      subject.instance_eval{ @tokens }.keys.must_include :cards
      subject.instance_eval{ @tokens }.keys.must_include :emails
      subject.instance_eval{ @tokens }.keys.wont_include :members
    end

    it "generates tokens for only the specified target type" do
      @dummy_session.expects(:security_key).with(any_parameters) { |options| options.has_key? :card }.returns(@dummy_key)

      subject.send(:generate_tokens, :cards)

      subject.tokens.keys.must_equal [:cards]
    end
  end

  describe "#generate" do
    it "returns an association of buttons and the source value used to build them" do
      
    end
  end

  describe "#build" do
    before do
      AtPay::Button::Button.expects(:button).at_least_once.with(:card, /.*/)
    end

    it "passes the source information to the Button class" do
      subject.send(:build, :card, 'bob')
    end
  end
end
