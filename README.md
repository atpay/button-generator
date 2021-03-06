# @Pay Payment Button Generator

The @Pay payment button generator creates @Pay two-click buttons that you can send
to your mailing list to collect funds via email. 

When using two-click buttons in emails, you want to make sure that they are compatible
in as many environments (clients/browsers/devices) as possible. This can be a painstaking
task because all environments render buttons differently. Buttons generated with this
tool are cross-platform and cross-browser compatible. This means that the two-click
experience can be enjoyed on over 93% of browser, platform, and device combinations.
The generator uses domain targeting and outputs html from a specific template depending
on the email parameter. These templates include two sets of buttons. A CSS rule set will
determine which button will be displayed on the end users device and browser. For more
information on cross compatibility, 
visit https://www.atpay.com/cross-compatible-mailto-links-mobile-browsers.

You can use this library directly from your Ruby-based application, or you can
interface with it via the command line from most any language.

The provided Liquid templates are customizable here, or can be used as
a starting point for your own implementation.

This library is a convenience wrapper around the [@Pay Client
Library](https://github.com/atpay/atpay-client). You may use both together or
each independently, though this library does internally depend on the client
library.


## Installation

If your application is based on Ruby and you use Bundler, add the following line
to your application's Gemfile:

    gem 'atpay_buttons'

And then execute:

    $ bundle

If you'd like to use the command line interface, or are not using Bundler, you
can install the gem on your system with:

    $ gem install atpay_buttons

## Requirements

Ruby >= 1.9

## Command Line Usage

You'll need a partner id, public key and private key from your @Pay signup. More
advanced implementations may be using OAuth to collect this information from
multiple partners and can generate buttons on behalf of merchants that use their
system. 

After installing the atpay-button-generator gem, you'll have
`atpay_buttons` script in your gem binpath. Run it with
the help flag to get information on how to use it: 


    $ atpay_buttons --help

The button generator requires a few flags up front:

### Parameters

<p><strong>amount (required): </strong> <br />
<i> &nbsp; &nbsp; &nbsp; The amount a user should be charged for transactions after clicking this button</i></p>
 
<p><strong>private-key (required):</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The private key given to you by @Pay</i></p>

<p><strong>public-key (required):</strong> <br />
<i> &nbsp; &nbsp; &nbsp; @Pay's public key, given to you by @Pay</i></p>

<p><strong>partner-id (required):</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The partner ID given to you by @Pay</i></p>

<p><strong><sup>**</sup>universal:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; This flag indicates that a universal payment button should be returned.</i></p>

<p><strong>subject:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The subject of the mailto: email <br/> &nbsp; &nbsp; &nbsp; (the message that a user will be sending to @Pay's servers after clicking the button)</i></p>

<p><strong>signup-url:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The signup URL for a Universal Button offer.  This option should only be present if you use the universal flag.</i></p>

<p><strong>image:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The URL to a small thumbnail image to be used in the button <br /> &nbsp; &nbsp; &nbsp; Default: https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png</i></p>

<p><strong>background-color:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The background color of the button <br /> &nbsp; &nbsp; &nbsp;  Default: #6dbe45</i></p>

<p><strong>foreground-color:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The foreground color of the button <br /> &nbsp; &nbsp; &nbsp;  Default: #ffffff</i></p>

<p><strong>title:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; The title for each button</i></p>

<p><strong>wrap:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; Will use wrapped (with a styled div container) version of template <br /> &nbsp; &nbsp; &nbsp; Default: false</i></p>

<p><strong>wrap-text:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; Text to use within the wrapper <br /> &nbsp; &nbsp; &nbsp; Default: "Made for Mobile"</i></p>

<p><strong>templates:</strong> <br />
<i> &nbsp; &nbsp; &nbsp; Location of button templates <br /> &nbsp; &nbsp; &nbsp; Default: ./lib/atpay/button/templates</i></p>

<p><strong>env:</strong> <br /> 
<i> &nbsp; &nbsp; &nbsp; The environment you want to generate buttons for; currently sandbox or production<br /> &nbsp; &nbsp; &nbsp; Default: production</i></p>

<p><strong>user_data:</strong> <br /> 
<i> &nbsp; &nbsp; &nbsp; Optional user data to be passed in as a string for your use </i></p>

<p><strong>input: </strong> <br /> 
<i> &nbsp; &nbsp; &nbsp; Input File
<br />&nbsp; &nbsp; &nbsp;Default: $stdin<sup>*</sup></i></p>

<sup>*</sup>Reads from STDIN a comma delimmited file with each line containing the
email address you're sending the button to and the credit card token you've

<sup>**</sup>With a universal button the program doesn't look for an input stream, as it only ever generates one button.

received from @Pay for that button:

    test1@example.com,TL1UwJFXVN7e4p6+0B5N8hy4qQyqeNxVllmC663MLcMupuAWXdHJ9g8PRAnlIh+AMZBgpaIrfWStZ5/3hYi6vCAV7q6+3M6LLqxk
    test2@example.com,XKCF2E9QZPwdOSwfTQJzZC7byLt3PH8Tr1KhmLkfRHwfNJD5XbDRMrxGYOiSnfrLEKNzm9+a4r++bpUG2hNrPyYLpNgph3BXAAfC
    test3@example.com,iQOxdBV4KrFuPFgyywxytfbsD/rURrzmlADmg1QFP2VHd/kTnkXNpnp2Utv4RS0Zz2YeOloilMhljsOcRVA2YwSu9knwF1h6tNjE

### Example

    $ atpay_buttons --title "Pay" --amount 50.00 --subject "Payment for fifty bucks" --private-key "" --public-key "" --partner-id 20 --input input.txt

Where input.txt contains

    test1@example.com,TL1UwJFXVN7e4p6+0B5N8hy4qQyqeNxVllmC663MLcMupuAWXdHJ9g8PRAnlIh+AMZBgpaIrfWStZ5/3hYi6vCAV7q6+3M6LLqxk
    test2@example.com,XKCF2E9QZPwdOSwfTQJzZC7byLt3PH8Tr1KhmLkfRHwfNJD5XbDRMrxGYOiSnfrLEKNzm9+a4r++bpUG2hNrPyYLpNgph3BXAAfC
    test3@example.com,iQOxdBV4KrFuPFgyywxytfbsD/rURrzmlADmg1QFP2VHd/kTnkXNpnp2Utv4RS0Zz2YeOloilMhljsOcRVA2YwSu9knwF1h6tNjE

will output three buttons, one for each of the email addresses above, in HTML
format, one per line. If you're sending out one offer per email, you'll simply
include each line in the outgoing message to the recipient (one to
test1@example.com, one to test2@example.com, and one to test3@example.com).

A button from the example above looks like this:

![Example Button](https://github.com/atpay/button-generator/blob/master/imgs/sample_button.png?raw=true)


## Library Usage

After following the installation instructions above, you'll have the @Pay button
generator library loaded in your application. Let's create an array containing
hashes with our users' email address and html code for a button to deliver to
them:

```ruby
  require 'atpay_buttons'

  button_maker = AtPay::Button::Generator.new({
    public_key: ATPAY_PUBLIC,
    private_key: ATPAY_PRIVATE,
    partner_id: ATPAY_PARTNER,
    environment: :sandbox,
    amount: 20
  })

  output = []

  User.active.each do |user|
    output << {
      email: user.email,
      button_html: button_maker.generate email: user.email, source: user.source
    }
  end

  puts output.inspect
```  

Generating a Universal button is similar to the process above.  However as the same button will work for multiple buyers you only need to make the one call to generate.  The source should be the URL a customer should visit to register their card info with @Pay.  This can be any page that implements the @Pay Javascript SDK.

```
  require 'atpay_buttons'

  button_maker = AtPay::Button::Generator.new({
    public_key: ATPAY_PUBLIC,
    private_key: ATPAY_PRIVATE,
    partner_id: ATPAY_PATNER,
    environment: :sandbox,
    amount: 20
  })

  puts button_maker.generate email: 'none', type: :url, source: 'https://special.example.com/signup'
```

### ActionMailer Example

Assume you have a model that represents an offer you'd like to send to a user:

```ruby
  class OfferMailer < ActionMailer::Base
    default from: 'offers@example.com'

    def offer_email(offer)
      @button = generator.generate({
        email: offer.recipient.email,
        source: offer.recipient.card_token
      })

      mail({ 
        to: offer.recipient.email,
        subject: offer.name
      })
    end

    private
    def generator
      AtPay::Button::Generator.new({
        amount: offer.amount
      }.update(atpay_config))
    end

    # NOTE: Just throw this in an initializer if you can
    def atpay_config
      {
        public_key: ATPAY_PUBLIC,
        private_key: ATPAY_PRIVATE,
        partner_id: ATPAY_PARTNER,
        environment: (Rails.env != "production") ? :sandbox : :production
      }
    end
end
```

## Templates


The generator uses a set of four default templates located in "lib/atpay/button/templates/". The yahoo.liquid template will be used for yahoo emails. The default.liquid template is for all other email providers. There are also versions prefixed with "wrap_" that will be used if the wrap parameter is set to "true". These "wrapped" templates are simply versions with a styled div that hold the buttons. 

To use your own custom templates, you can download the provided default versions. After making the desired modifications, set the template parameter to the location of your modified templates.  
