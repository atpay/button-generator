# @Pay Payment Button Generator

The @Pay payment button generator creates @Pay 2-click buttons that you can send
to your mailing list to collect funds via email. This library wraps the @Pay
email tokens generated with the [@Pay Client
Library](https://github.com/atpay/atpay-client), but handles the complexity of
email client compatibility for you. 

You can use this library directly from your ruby-based application, or you can
interface iwth it via the command line from most any language.

The provided Liquid templates are customizable here, or can be used as
a starting point for your own implementation.

## Installation

If your application is based on ruby and you use Bundler, add the following line
to your application's Gemfile:

    gem 'atpay-button-generator'

And then execute:

    $ bundle

If you'd like to use the command line interface, or are not using Bundler, you
can install the gem on your system with:

    $ gem install atpay-button-generator

## Requirements

ruby >= 1.9

## Command Line Usage

You'll need a partner id, public key and private key from your @Pay signup. More
advanced implementations may be using OAuth to collect this information from
multiple partners and can generate buttons on behalf of merchants that use their
system. 

After installing the atpay-button-generator gem, you'll have
`atpay-button-generator` script in your gem binpath. By running it directly
you'll get help output:

    $ atpay-button-generator

The button generator requires a few flags up front:

### Parameters

<strong>amount (required): </strong> 
<pre>   The amount a user should be charged for transactions after clicking this button</pre>
 
<strong>private-key (required):</strong>
<pre>   The private key given to you by @Pay</pre>

<strong>public-key (required):</strong>
<pre>   @Pay's public key, given to you by @Pay</pre>

<strong>partner-id (required):</strong>
<pre>   The partner ID given to you by @Pay</pre>

<strong>subject:</strong>
<pre>   The subject of the mailto: email (the message that a user will be sending to @Pay's servers after clicking the button)</pre>


<strong>image:</strong>
<pre>   The URL to a small thumbnail image to be used in the button. Default: https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png</pre>


<strong>color:</strong>
<pre>   The background color of the button.  Default: #6dbe45</pre>

<strong>title:</strong>
<pre>   The title for each button</pre>

<strong>wrap:</strong>
<pre>   Will use wrapped (with a styled div container) version of template.  Default: false</pre>


<strong>templates:</strong>
<pre>   Location of button templates.  Default: ./lib/atpay/button/templates</pre>

And then reads from STDIN a comma delimmited file with each line containing the
email address you're sending the button to and the credit card token you've
received from @Pay for that button:

    test1@example.com,TL1UwJFXVN7e4p6+0B5N8hy4qQyqeNxVllmC663MLcMupuAWXdHJ9g8PRAnlIh+AMZBgpaIrfWStZ5/3hYi6vCAV7q6+3M6LLqxk
    test2@example.com,XKCF2E9QZPwdOSwfTQJzZC7byLt3PH8Tr1KhmLkfRHwfNJD5XbDRMrxGYOiSnfrLEKNzm9+a4r++bpUG2hNrPyYLpNgph3BXAAfC
    test3@example.com,iQOxdBV4KrFuPFgyywxytfbsD/rURrzmlADmg1QFP2VHd/kTnkXNpnp2Utv4RS0Zz2YeOloilMhljsOcRVA2YwSu9knwF1h6tNjE

### Example

    $ atpay-button-generator --title "Pay" --amount 50.00 --subject "Payment for fifty bucks" --private-key "" --public-key "" --partner-id 20 < input.txt

Where input.txt contains

    test1@example.com,TL1UwJFXVN7e4p6+0B5N8hy4qQyqeNxVllmC663MLcMupuAWXdHJ9g8PRAnlIh+AMZBgpaIrfWStZ5/3hYi6vCAV7q6+3M6LLqxk
    test2@example.com,XKCF2E9QZPwdOSwfTQJzZC7byLt3PH8Tr1KhmLkfRHwfNJD5XbDRMrxGYOiSnfrLEKNzm9+a4r++bpUG2hNrPyYLpNgph3BXAAfC
    test3@example.com,iQOxdBV4KrFuPFgyywxytfbsD/rURrzmlADmg1QFP2VHd/kTnkXNpnp2Utv4RS0Zz2YeOloilMhljsOcRVA2YwSu9knwF1h6tNjE

will output three buttons, one for each of the email addresses above, in HTML
format, one per line. If you're sending out one offer per button, you'll simply
include each line in the outgoing message to the recipient (one to
test1@example.com, one to test2@example.com, and one to test3@example.com).

will output the following to STDOUT:
 
    test1@example.com <button_html>
    test2@example.com <button_html>
    test3@example.com <button_html>


the button in the example above looks like this:

![Example Button](https://github.com/atpay/button-generator/blob/master/imgs/sample_button.png?raw=true)

## Library Usage


## Templates

When using 2-click buttons in emails you want to make sure that they are compatible in as many environments (clients/browsers/devices) as possible. This can be a painstaking task because all environments render buttons differently. Buttons generated with this tool are cross platform and cross browser compatible. This means that the two-click experience can be enjoyed on over 93% of all browsers on all devices. The generator uses domain targeting and outputs html from a specific template depending on the email parameter. These templates include two sets of buttons. A CSS rule set will determine which button will be displayed on the end users device and browser. For more information on cross compatibility, visit https://www.atpay.com/cross-compatible-mailto-links-mobile-browsers.

The generator uses a set of four default templates located in "lib/atpay/button/templates/". The yahoo.liquid template will be used for yahoo emails. The default.liquid template is for all other email providers. There are also versions prefixed with "wrap_" that will be used if the wrap parameter is set to "true". These "wrapped" templates are simply versions with a styled div that hold the buttons. 

To use your own custom templates, you can download the provided default versions. After you make your modifications, set the template parameter to the location of your modified templates.  
