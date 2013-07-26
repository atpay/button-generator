require 'spec_helper'

describe AtPay::Button::Generator do
  let(:session) { mock }
  let(:public_key) { '06zK82iu9NUUMmDiZsEvoUH25tbIE6R3R+zPnDK8YGQ=' }
  let(:private_key) { 'plBs9X+Zvr65z6iCa0oLNdAEGYZ85Dzf74Qy1yPTris=' }
  let(:options) { {partner_id: 1, public_key: public_key, private_key: private_key, amount: '12', env: :sandbox, user_data: 'aaaaaaaa'} }
  let(:subject) { AtPay::Button::Generator.new options }

  describe "#new" do
    it "adds the provided options to the defaults" do
      subject.instance_eval{ @options }.keys.sort.must_equal [:amount, :partner_id, :public_key, :private_key, :env, :template, :title, :type, :group, :user_data].sort
    end
  end

  describe "#token" do
    before do
      @dummy_key = mock
      session.expects(:security_key).returns(@dummy_key)
      AtPay::Session.stubs(:new).returns(session)
    end

    it "builds an @Pay token" do
      @dummy_key.expects :email_token

      subject.token(:card, '3838383')
    end
  end

  describe "#template" do
    it "instantiates the template for the given email" do
      AtPay::Button::Template.expects(:new).with(any_parameters) { |options| options[:email] == 'bob@bob' }

      subject.template 'bob@bob'
    end
  end

  describe "#to_html" do
    it "renders the template with the given token" do
      AtPay::Button::Template.any_instance.expects(:render).with(token: 'token', email: 'bob@bob')

      subject.to_html 'token', 'bob@bob'
    end
  end

  describe "#generate" do
    before do
      @dummy_key = mock
      @dummy_key.expects(:email_token).returns('token')
      AtPay::Button::Template.any_instance.expects(:render).returns('button')
      session.expects(:security_key).returns(@dummy_key)
      AtPay::Session.stubs(:new).returns(session)
    end

    it "builds an html button when given only the email" do
      subject.generate(email: 'bob@bob').must_equal 'button'
    end

    it "builds an html button when given the email and source" do
      subject.generate(email: 'bob@bob', source: '3838383').must_equal 'button'
    end

    it "builds an html button when given the email, source and type" do
      subject.generate(email: 'bob@bob', source: '38383838', type: :card).must_equal 'button'
    end
  end

  describe "#build" do
    before do
      AtPay::Button::Generator.any_instance.stubs(:generate).returns('button')
      AtPay::Session.stubs(:new).returns(session)
    end

    it "builds a collection of buttons" do
      subject.build({ 'bob@bob' => 'card', 'sue@sue' => 'card' }).must_equal [['bob@bob', 'button'], ['sue@sue', 'button']]
    end

    it "builds a single button" do
      subject.build({ 'bob@bob' => 'card' }).must_equal [['bob@bob', 'button']]
    end

    it "builds a button when only given an email" do
      subject.build(['bob@bob']).must_equal [['bob@bob', 'button']]
    end
  end
end
