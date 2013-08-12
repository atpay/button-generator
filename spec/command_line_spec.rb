require 'spec_helper'

describe "atpay_buttons" do
  let(:session) { mock }
  let(:file_info) { 'test_data.txt' }
  let(:public_key) { '06zK82iu9NUUMmDiZsEvoUH25tbIE6R3R+zPnDK8YGQ=' }
  let(:private_key) { 'plBs9X+Zvr65z6iCa0oLNdAEGYZ85Dzf74Qy1yPTris=' }
  let(:options) { {partner_id: 1, public_key: public_key, private_key: private_key, amount: '12', env: :sandbox, user_data: 'aaaaaaaa'} }
  let(:cli_input) { "bin/atpay_buttons --amount 5.0 -p #{private_key} -u #{public_key} -r #{options[:partner_id]} -s subject -i imageurl -c color -t title -w false -e sandbox -n #{file_info}" }
  let(:cli_output) {`#{cli_input}`}

  describe "button creation" do
    it "creates a string based on passed in parameters" do
      refute_empty(cli_output)
      cli_output.must_be_instance_of String
    end

    it "contains button identifier text" do
      cli_output.must_include 'mailto'
    end

    it "generates valid usage information" do
      assert_match(/--help, -h:   Show this message/,`bin/atpay_buttons -h`)
    end

    #it "displays a message if the input file is missing" do
    #  cli_output = `atpay-button-generator -n missing.txt`
    #  assert_match(/Error: file or url for option '-n' cannot be opened: No such file or directory/, cli_output)
    #end
  end
end
