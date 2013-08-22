require 'spec_helper'

describe AtPay::Button::Template do
  let(:session) { mock }
  let(:options) { {destination: "Partner Name", email: 'bob@example.com', amount: 20, templates: "spec/fixtures/templates" } }
  let(:subject) { AtPay::Button::Template.new options }
  let(:subject_class) { AtPay::Button::Template }

  describe "#new" do
    it "adds the provided options to the defaults" do
      subject.instance_eval{ @options }.keys.sort.must_equal [:subject, :title, :background_color, :foreground_color, :image, :processor, :destination, :templates, :email, :amount, :wrap, :wrap_text].sort
    end
  end

  describe "#render" do
    it "renders yahoo specific templates for yahoo providers" do
      %w(test@yahoo.com test@ymail.com test@rocketmail.com).each do |email|
        subject.instance_eval { 
          @options[:email] = email 
        }

        subject.render.strip.must_equal "Yahoo"
      end
    end

    it "renders wrapped version of yahoo template for yahoo providers" do
      %w(test@yahoo.com test@ymail.com test@rocketmail.com).each do |email|
        subject.instance_eval { 
          @options[:email] = email 
          @options[:wrap] = true 
        }

        subject.render.strip.must_equal "Yahoo Wrap"
      end
    end

    it "renders default template for all other providers" do
      subject.instance_eval { 
        @options[:email] = "test@atpay.com" 
      }

      subject.render.strip.must_equal "Default"
    end

    it "renders wrapped version of default template for other providers" do
      subject.instance_eval { 
        @options[:email] = "test@atpay.com" 
        @options[:wrap] = true
      }

      subject.render.strip.must_equal "Default Wrap"
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
