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

--amount (required):
  The amount a user should be charged for transactions after clicking this
button

--private-key (required):
  The private key given to you by @Pay

--public-key (required):
  @Pay's public key, given to you by @Pay

--partner-id (required):
  The partner ID given to you by @Pay

--subject:
  The subject of the mailto: email (the message that a user will be sending to
@Pay's servers after clicking the button)

--image:
   The URL to a small thumbnail image to be used in the button. Default: https://www.atpay.com/wp-content/themes/atpay/images/bttn_cart.png

--color:
   The background color of the button.  Default: #6dbe45

--title:
  The title for each button

--wrap:
   Will use wrapped (with a styled div container) version of template.  Default: false

--templates:
   Location of button templates.  Default: ./lib/atpay/button/templates

And then reads from STDIN a comma delimmited file with each line containing the
email address you're sending the button to and the credit card token you've
received from @Pay for that button:

    test1@example.com,TL1UwJFXVN7e4p6+0B5N8hy4qQyqeNxVllmC663MLcMupuAWXdHJ9g8PRAnlIh+AMZBgpaIrfWStZ5/3hYi6vCAV7q6+3M6LLqxk
    test2@example.com,XKCF2E9QZPwdOSwfTQJzZC7byLt3PH8Tr1KhmLkfRHwfNJD5XbDRMrxGYOiSnfrLEKNzm9+a4r++bpUG2hNrPyYLpNgph3BXAAfC
    test3@example.com,iQOxdBV4KrFuPFgyywxytfbsD/rURrzmlADmg1QFP2VHd/kTnkXNpnp2Utv4RS0Zz2YeOloilMhljsOcRVA2YwSu9knwF1h6tNjE

### Example

    $ atpay-button-generator --title "Pay" --amount 50.00 --subject="Payment for fifty bucks" --private-key "" --public-key "" --partner-id 20 < input.txt

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

<style>
  .ExternalClass a.outlook {display:inline; display: inline !important;font-size: 20px !important;}
  .ExternalClass a.outlooksm {display:inline; display: inline !important;font-size: 12px !important;}
  .ExternalClass a.not_outlook {display:none; display: none !important;}
  .ExternalClass a.outlook table {background-color:#6dbe45 !important; font-size:10px !important; }
  .ExternalClass a.outlook table td.main {width:145px !important; padding:3px 5px 5px 5px !important;}
  .ExternalClass a.outlook table td img {width:auto !important; height: 39px !important; margin-left: 5px !important; margin-right:10px !important; margin-top:8px !important;}
  .ExternalClass a.outlook table.sub {width: auto !important; height: auto !important;}
  .ExtenralClass a.outlook td.title {font-size: 11px !important ; color: #ffffff; font-family: Tahoma; text-align:center; padding:0; margin:0;}
  .ExternalClass a.outlook table.subB{float:left; margin:0; margin-left:5px !important;}
</style>
<center>

  <a border='0' class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='text-underline:none;'>
    <table border='0' cellpadding='0' cellspacing='0' style='background-color:#6dbe45;'>
      <tr class='main'>
        <td class='main' style='padding:3px 5px 5px 5px;' width='145'>
          <table>
            <tr>
              <td>
                <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                  <img src='' style='margin-left: 5px; margin-right:10px; margin-top:8px;'>
                </a>
              </td>
              <td>
                <table border='0' cellpadding='0' cellspacing='0' style='float:left; margin:0; margin-left:5px;'>
                  <tr>
                    <td style='font-size: 11px; color: #ffffff; font-family: Tahoma; text-align:center; padding:0; margin:0;'>
                      
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table border='0' cellpadding='0' cellspacing='0' style='margin:0; padding:0;'>
                        <tr>
                          <td style='padding:0; margin:0; font-size: 20px; color: #ffffff; font-family: Tahoma; vertical-align:top; line-height:25px;' valign='top'>
                            <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                              $12
                            </a>
                          </td>
                          <td style='padding:0; margin:0; font-size:14px; text-decoration:underline;padding-left:2px; color: #ffffff; font-family: Tahoma; vertical-align:top;' valign='top'>
                            <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                              00
                            </a>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </a>
  <a border='0' class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='text-underline:none;  font-size:0px;  width:0px; height: 0px;'>
    <table border='0' cellpadding='0' cellspacing='0' height='0' style='background-color:#ffffff; overflow: hidden;  font-size: 0px; ' width='0'>
      <tr class='main'>
        <td class='main' style='padding: 0px;' width='0'>
          <table border='0' cellpadding='0' cellspacing='0' class='sub' height='' style='background-color:#ffffff; overflow: hidden;' width=''>
            <tr>
              <td style='line-height:1px;'>
                <a class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                  <img height='1' src='' style='text-indent:-9999px; margin: 0px; width:1px; height:1px' width='1'>
                </a>
              </td>
              <td>
                <table border='0' cellpadding='0' cellspacing='0' class='subB' style='float:left; margin:0; margin-left:0px;'>
                  <tr>
                    <td class='title' style='font-size: 0px; color: #ffffff; font-family: Tahoma; text-align:center; padding:0; margin:0;'>
                      
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table border='0' cellpadding='0' cellspacing='0' style='margin:0; padding:0;'>
                        <tr>
                          <td style='padding:0; margin:0; font-size: 0px; color: #ffffff; font-family: Tahoma; vertical-align:top; line-height:0px;' valign='top'>
                            <a class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                              $12
                            </a>
                          </td>
                          <td style='padding:0; margin:0; font-size:0px; text-decoration:underline;padding-left:0px; color: #ffffff; font-family: Tahoma; vertical-align:top;' valign='top'>
                            <a class='outlooksm' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                              00
                            </a>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </a>
</center>

<center>

  <a border='0' class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='text-underline:none;'>
    <table border='0' cellpadding='0' cellspacing='0' style='background-color:#6dbe45;'>
      <tr class='main'>
        <td class='main' style='padding:3px 5px 5px 5px;' width='145'>
          <table>
            <tr>
              <td>
                <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                  <img src='' style='margin-left: 5px; margin-right:10px; margin-top:8px;'>
                </a>
              </td>
              <td>
                <table border='0' cellpadding='0' cellspacing='0' style='float:left; margin:0; margin-left:5px;'>
                  <tr>
                    <td style='font-size: 11px; color: #ffffff; font-family: Tahoma; text-align:center; padding:0; margin:0;'>
                      
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table border='0' cellpadding='0' cellspacing='0' style='margin:0; padding:0;'>
                        <tr>
                          <td style='padding:0; margin:0; font-size: 20px; color: #ffffff; font-family: Tahoma; vertical-align:top; line-height:25px;' valign='top'>
                            <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                              $12
                            </a>
                          </td>
                          <td style='padding:0; margin:0; font-size:14px; text-decoration:underline;padding-left:2px; color: #ffffff; font-family: Tahoma; vertical-align:top;' valign='top'>
                            <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                              00
                            </a>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </a>
  <a border='0' class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='text-underline:none;  font-size:0px;  width:0px; height: 0px;'>
    <table border='0' cellpadding='0' cellspacing='0' height='0' style='background-color:#ffffff; overflow: hidden;  font-size: 0px; ' width='0'>
      <tr class='main'>
        <td class='main' style='padding: 0px;' width='0'>
          <table border='0' cellpadding='0' cellspacing='0' class='sub' height='' style='background-color:#ffffff; overflow: hidden;' width=''>
            <tr>
              <td style='line-height:1px;'>
                <a class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                  <img height='1' src='' style='text-indent:-9999px; margin: 0px; width:1px; height:1px' width='1'>
                </a>
              </td>
              <td>
                <table border='0' cellpadding='0' cellspacing='0' class='subB' style='float:left; margin:0; margin-left:0px;'>
                  <tr>
                    <td class='title' style='font-size: 0px; color: #ffffff; font-family: Tahoma; text-align:center; padding:0; margin:0;'>
                      
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table border='0' cellpadding='0' cellspacing='0' style='margin:0; padding:0;'>
                        <tr>
                          <td style='padding:0; margin:0; font-size: 0px; color: #ffffff; font-family: Tahoma; vertical-align:top; line-height:0px;' valign='top'>
                            <a class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                              $12
                            </a>
                          </td>
                          <td style='padding:0; margin:0; font-size:0px; text-decoration:underline;padding-left:0px; color: #ffffff; font-family: Tahoma; vertical-align:top;' valign='top'>
                            <a class='outlooksm' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                              00
                            </a>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </a>
</center>

<center>

  <a border='0' class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='text-underline:none;'>
    <table border='0' cellpadding='0' cellspacing='0' style='background-color:#6dbe45;'>
      <tr class='main'>
        <td class='main' style='padding:3px 5px 5px 5px;' width='145'>
          <table>
            <tr>
              <td>
                <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                  <img src='' style='margin-left: 5px; margin-right:10px; margin-top:8px;'>
                </a>
              </td>
              <td>
                <table border='0' cellpadding='0' cellspacing='0' style='float:left; margin:0; margin-left:5px;'>
                  <tr>
                    <td style='font-size: 11px; color: #ffffff; font-family: Tahoma; text-align:center; padding:0; margin:0;'>
                      
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table border='0' cellpadding='0' cellspacing='0' style='margin:0; padding:0;'>
                        <tr>
                          <td style='padding:0; margin:0; font-size: 20px; color: #ffffff; font-family: Tahoma; vertical-align:top; line-height:25px;' valign='top'>
                            <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                              $12
                            </a>
                          </td>
                          <td style='padding:0; margin:0; font-size:14px; text-decoration:underline;padding-left:2px; color: #ffffff; font-family: Tahoma; vertical-align:top;' valign='top'>
                            <a class='not_outlook' href='mailto:transaction@secure.atpay.com?subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none; display:inline;'>
                              00
                            </a>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </a>
  <a border='0' class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='text-underline:none;  font-size:0px;  width:0px; height: 0px;'>
    <table border='0' cellpadding='0' cellspacing='0' height='0' style='background-color:#ffffff; overflow: hidden;  font-size: 0px; ' width='0'>
      <tr class='main'>
        <td class='main' style='padding: 0px;' width='0'>
          <table border='0' cellpadding='0' cellspacing='0' class='sub' height='' style='background-color:#ffffff; overflow: hidden;' width=''>
            <tr>
              <td style='line-height:1px;'>
                <a class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                  <img height='1' src='' style='text-indent:-9999px; margin: 0px; width:1px; height:1px' width='1'>
                </a>
              </td>
              <td>
                <table border='0' cellpadding='0' cellspacing='0' class='subB' style='float:left; margin:0; margin-left:0px;'>
                  <tr>
                    <td class='title' style='font-size: 0px; color: #ffffff; font-family: Tahoma; text-align:center; padding:0; margin:0;'>
                      
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table border='0' cellpadding='0' cellspacing='0' style='margin:0; padding:0;'>
                        <tr>
                          <td style='padding:0; margin:0; font-size: 0px; color: #ffffff; font-family: Tahoma; vertical-align:top; line-height:0px;' valign='top'>
                            <a class='outlook' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                              $12
                            </a>
                          </td>
                          <td style='padding:0; margin:0; font-size:0px; text-decoration:underline;padding-left:0px; color: #ffffff; font-family: Tahoma; vertical-align:top;' valign='top'>
                            <a class='outlooksm' href='https://www.hotmail.com/secure/start?action=compose&to=transaction@secure.atpay.com&subject=Submit%20@Pay%20Payment&body=Please%20press%20send%20to%20complete%20your%20transaction.%20Thank%20you%20for%20your%20payment%20of%20$12.00%20to%20.%20Your%20receipt%20will%20be%20emailed%20to%20you%20shortly.%20Here%20is%20the%20ID%20code%20that%20will%20expedite%20your%20transaction%20%0A' style='color:#ffffff; text-decoration:none; border:none;'>
                              00
                            </a>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </a>
</center>


## Library Usage


## Templates

When using 2-click buttons in emails you want to make sure that they are compatible in as many environments (clients/browsers/devices) as possible. This can be a painstaking task because all environments render buttons differently. Buttons generated with this tool are cross platform and cross browser compatible. This means that the two-click experience can be enjoyed on over 93% of all browsers on all devices. The generator uses domain targeting and outputs html from a specific template depending on the email parameter. These templates include two sets of buttons. A CSS rule set will determine which button will be displayed on the end users device and browser. For more information on cross compatibility, visit https://www.atpay.com/cross-compatible-mailto-links-mobile-browsers.

The generator uses a set of four default templates located in "lib/atpay/button/templates/". The yahoo.liquid template will be used for yahoo emails. The default.liquid template is for all other email providers. There are also versions prefixed with "wrap_" that will be used if the wrap parameter is set to "true". These "wrapped" templates are simply versions with a styled div that hold the buttons. 

To use your own custom templates, you can download the provided default versions. After you make your modifications, set the template parameter to the location of your modified templates.  
