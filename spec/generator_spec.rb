require 'spec_helper'

describe AtPay::Button::Generator do
  let(:session) { mock }
  let(:options) { {partner_id: 1, public_key: 'bob', private_key: 'privatebob', environment: :sandbox, template: {}} }
  let(:subject) { AtPay::Button::Generator.new session, options }

  describe "#new" do
    it "adds the provided options to the defaults" do
      subject.instance_eval{ @options }.keys.sort.must_equal [:partner_id, :public_key, :private_key, :template, :environment, :title, :type, :group, :user_data].sort
    end
  end

  describe "#token" do
    before do
      @dummy_key = mock
      session.expects(:security_key).returns(@dummy_key)
    end

    it "builds an @Pay token" do
      @dummy_key.expects :email_token

      subject.token(:card, '3838383')
    end
  end

  describe "#template" do
    it "loads the template if not already loaded" do
      AtPay::Button::Template.expects(:new)

      subject
    end

    it "does't load the template if it has already been loaded" do
      subject.template
      AtPay::Button::Template.expects(:new).never

      subject.template
    end
  end

  describe "#to_html" do
    it "renders the template with the given token" do
      subject.template
      AtPay::Button::Template.any_instance.expects(:render).with(token: 'token')

      subject.to_html 'token'
    end
  end

  describe "#build" do
    it "initiates the process and returns the rendered template code" do
      @dummy_key = mock
      @dummy_key.expects(:email_token).returns('token')
      AtPay::Button::Template.any_instance.expects(:render).returns('button')
      session.expects(:security_key).returns(@dummy_key)

      subject.build(:card, 'card').must_equal 'button'
    end
  end
end