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



## Parameters

<b>image :</b>
<pre>
   The URL to a small thumbnail image to be used in the button.
   Default: https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png
</pre>


<b>color: </b>
<pre>
   The background color of the button.
   Default: #6dbe45
</pre>


<b>title:</b>
<pre>
   String of text that will appear in generated button.
   Default: Pay
</pre>


<b>wrap:</b>
<pre>
   Will use wrapped (with a styled div container) version of template.
   Default: false
</pre>



<b>templates:</b>
<pre>
   Location of button templates. 
   Default: /lib/atpay/button/templates
</pre> 






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
