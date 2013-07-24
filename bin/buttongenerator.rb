#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'pry'
require 'atpay'

class String
  def squish
    gsub!(/\A[[:space:]]+/, '')
    gsub!(/[[:space:]]+\z/, '')
    gsub!(/[[:space:]]+/, ' ')
    self
  end
end

class ButtonClient

  attr_accessor :amount,
    :email,
    :owner,
    :wrapper,
    :image,
    :color,
    :type,
    :user_data,
    :button_generator

  def initialize(options)
    self.amount = options[:amount]
    self.email = options[:email]
    self.owner = options[:owner]
    self.wrapper = options[:wrapper]
    self.image = options[:image]
    self.color = options[:color]
    self.type = options[:type]
    self.user_data = options[:user_data]
    self.button_generator = ButtonGenerator.new options
  end

  def generate_button(button_type)
    if button_type == 'prospect'
      self.button_generator.prospect_button.to_html
    elsif button_type == 'member'
      self.button_generator.member_button(self.owner).to_html 
    else
      puts "First argument must be either prospect or member"
      exit
    end
  
  end

  def self.usage

    usage = <<-'USAGE'
      To generate an Atpay Button, use the following syntax:
      ruby buttongenerator.rb [prospect | member] [email] [default_partner_uuid] [wrapper] [image] [color] [type] [user_data]

      Prospect button creation example:
      ruby buttongenerator.rb prospect 50.00 tom@atpay.com A3232-WEWRW-WR23X-IK3E3J true someimg FFFEEE unsure non

      Member button creation example:
      ruby buttongenerator.rb member 50.00 tom@atpay.com A3232-WEWRW-WR23X-IK3E3J true someimg FFFEEE unsure non
    USAGE

    usage

  end

end

unless ARGV.length == 9
  puts ButtonClient.usage
  exit
end

args = ARGV
args = {:type => ARGV[0], :amount => ARGV[1], :email => ARGV[2], :owner => ARGV[3], :wrapper => ARGV[4], :image => ARGV[5], :color => ARGV[6], :type => ARGV[7], :user_data => ARGV[8]}

button = ButtonClient.new args

puts "Use the following code to generate a button on your page or email: "
puts button.generate_button(ARGV[0])
