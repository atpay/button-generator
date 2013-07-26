# Atpay::Button::Generator

Atpay button generator library.

## Installation

Add this line to your application's Gemfile:

    gem 'atpay-button-generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install atpay-button-generator

## Requirements

Ruby 3.2

## Installation

gem install atpay-button-generator

## Usage

To use the button generator, you can use STDIN to feed arguments to the generator and create buttons.
For example:

You have a file called button_arguments.txt which contains the following parameters:

  title,amount,email,subject,credit_card_token,image,color,wrap,templates
  title one,50,one@example.com,send money,@dsdsf2,myimg.jpg,#FFFEE
  title two,60,two@example.com,send money,@rfsf234,myimg.jpg,#FFFEE
  title three,50,three@example.com,send money,@vb321,myimg.jpg,#FFFEE

ruby atpay-button-generator.rb < button_arguments.txt


## Parameters


title:
  The title of each button

amount:
  The prices that each button should be associated with

email:
  The list of emails you wish to send to users

subject:
  The subject associated with each email that is sent when the button is clicked

credit_card_token:
  The credit card token associated with each email


image :
   The URL to a small thumbnail image to be used in the button.
   Default: https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png


color: 
   The background color of the button.
   Default: #6dbe45



title:
   String of text that will appear in generated button.
   Default: Pay



wrap:
   Will use wrapped (with a styled div container) version of template.
   Default: false



templates:
   Location of button templates. 
   Default: /lib/atpay/button/templates



## Templates

When using 2-click buttons in emails you want to make sure that they are compatible in as many environments (clients/browsers/devices) as possible. This can be a painstaking task because all environments render buttons differently. Buttons generated with this tool are cross platform and cross browser compatible. This means that the two-click experience can be enjoyed on over 93% of all browsers on all devices. The generator uses domain targeting and outputs html from a specific template depending on the email parameter. These templates include two sets of buttons. A CSS rule set will determine which button will be displayed on the end users device and browser. For more information on cross compatibility, visit https://www.atpay.com/cross-compatible-mailto-links-mobile-browsers.

The generator uses a set of four default templates located in "lib/atpay/button/templates/". The yahoo.liquid template will be used for yahoo emails. The default.liquid template is for all other email providers. There are also versions prefixed with "wrap_" that will be used if the wrap parameter is set to "true". These "wrapped" templates are simply versions with a styled div that hold the buttons. 

To use your own custom templates, you can download the provided default versions. After you make your modifications, set the template parameter to the location of your modified templates.  




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
=======
=======
button-generator
