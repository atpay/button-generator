require 'spec_helper'

describe AtPay::Button::Template do
  let(:session) { mock }
  let(:options) { {destination: "Partner Name", email: 'bob@example.com', amount: 20, templates: "spec/fixtures/templates" } }
  let(:subject) { AtPay::Button::Template.new options }
  let(:subject_class) { AtPay::Button::Template }

  describe "#new" do
    it "adds the provided options to the defaults" do
      subject.instance_eval{ @options }.keys.sort.must_equal [:subject, :title, :color, :image, :processor, :destination, :templates, :email, :amount].sort
    end
  end

  describe "#render" do
    it "renders outlook specific templates for outlook providers" do
      subject.instance_eval { @options[:email] = "test@hotmail.com" }
      subject.render.strip.must_equal "Outlook"
    end

    it "renders yahoo specific templates for yahoo providers" do
      %w(test@yahoo.com test@ymail.com test@rocketmail.com).each do |email|
        subject.instance_eval { @options[:email] = email }
        subject.render.strip.must_equal "Yahoo"
      end
    end

    it "renders default template for all other providers" do
      subject.instance_eval { @options[:email] = "test@atpay.com" }
      subject.render.strip.must_equal "Default"
    end
  end

  # Integration style tests
  describe "#templates" do
    let(:options) { {destination: "Partner Name", amount: 20 } }
    
    it "should render with all known template types" do
      %w(test@hotmail.com test@yahoo.com test@atpay.com).each do |email|
        subject.instance_eval { @options[:email] = email }
        subject.render
      end
    end
  end
end
