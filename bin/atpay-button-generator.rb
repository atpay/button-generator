#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'pry'
#require 'atpay'


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

    begin
      data = Array.new; set = Hash.new; n = 0
      keys = ARGF.readline.strip.split(',')
      unless keys.length == 9
        puts ButtonClient.usage
        exit
      end
      keys.each_index {|index| keys[index] = keys[index].to_sym }
      while !ARGF.eof?
        data[n] = ARGF.readline.strip.split(',')
        unless data[n].length == 9
          puts ButtonClient.usage
        end
        n += 1
      end
      keys.each do |k|
        (set[k] = Array.new) if !set.has_key?(k)
      end
      keys.each do |k|
        key_index = keys.index(k)
        data.each do |d|
          set[k] << d[key_index]
        end
      end
    rescue EOFError
      puts 'End of file reached'
    end
    puts set.to_s
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
      ruby buttongenerator.rb prospect 50.00 tom@example.com A3232-WEWRW-WR23X-IK3E3J true someimg FFFEEE unsure non

      Member button creation example:
      ruby buttongenerator.rb member 50.00 tom@example.com A3232-WEWRW-WR23X-IK3E3J true someimg FFFEEE unsure non
    USAGE
    usage
  end
end

class String
  def squish
    gsub!(/\A[[:space:]]+/, '')
    gsub!(/[[:space:]]+\z/, '')
    gsub!(/[[:space:]]+/, ' ')
    self
  end
end

#args = ARGV
#args = {:type => ARGV[0], :amount => ARGV[1], :email => ARGV[2], :owner => ARGV[3], :wrapper => ARGV[4], :image => ARGV[5], :color => ARGV[6], :type => ARGV[7], :user_data => ARGV[8]}


button = ButtonClient.new "test"

puts "Use the following code to generate a button on your page or email: "
