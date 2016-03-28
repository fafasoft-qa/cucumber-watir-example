#!/usr/bin/ruby
#Helper class.
require 'rubygems'
require 'watir-webdriver'
require 'mandrill'
require_relative  '../helper/api_common'
require_relative '../helper/common'
require 'json'

module Mandrill_API

  include PageObject
  include DataMagic

  # @param [API KEY] key
  def self.get_mandrill_key_data(key)
    runtime_env_type = FigNewton.env_type
    data = API_Common.get_mandrill_data
    result = data[runtime_env_type+'_'+key]
  end

  def self.search_email_by_recipient(mandrill,data, send_api_keys, recipient)
    query = data['query_full_email']+':'+recipient
    date_from = (Time.now.strftime('%Y/%m/%d')).to_s
    date_to = (Time.now.strftime('%Y/%m/%d')).to_s
    senders = [data['mail_sender']]
    limit = 1000
    result = mandrill.messages.search query, date_from, date_to, "", senders, send_api_keys, limit
  end


  def self.mandrill_content(mandrill,data,id)
    result = mandrill.messages.content id
  end

  def self.get_email_info_by_subject(email_list,destination,subject)
    emails = email_list.select{|email| email["subject"].match(subject)}
    email = emails.select{|email| email["email"] == destination}
    if email.empty?
      result = nil
    else
      result = email[0]
    end
  end

  def self.get_email_data(email, what)
    #read email body and extract requested value according 'what' parameter
    result = ''
    case what
      when 'permalink-url'
        begin
          permalink_url = email.scan(/"((\w+:\/\/)[-a-zA-Z0-9:@?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+\/ses\/.*?)"/)#email.scan(/at this url:<br\/><a href="((\w+:\/\/)[-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+\/ses\/.*?)" target="_blank">/)
          result = permalink_url[0][0]
          puts "Mandrill api - get email data - permalink url\t\t=> #{result.to_s}\n"
          result = permalink_url[0][0]
        end
      when 'guest-pin'
        begin
          guest_pin_t = email.scan(/<h3>(\d{7})<\/h3>/)
          result = guest_pin_t[0][0]
          puts "Mandrill api - get email data - guest pin\t\t=> #{result.to_s}\n"
          result = guest_pin_t[0][0]
        end
      when 'presenter-pin'
        begin
          presenter_pin_t = email.scan(/Your PIN Number for this event is:.*?(\d{7})./)
          result = presenter_pin_t[0][0]
          puts "Mandrill api - get email data - presenter pin\t\t=> #{result.to_s}\n"
          result = presenter_pin_t[0][0]
        end
      when 'guest-conf-id'
        begin
          guest_conf_t = email.scan(/<h3>(\d{4})<\/h3>/)
          result = guest_conf_t[0][0]
          puts "Mandrill api - get email data - guest conf id\t\t=> #{result.to_s}\n"
          result = guest_conf_t[0][0]
        end
      when 'presenter-conf-id'
        begin
          presenter_conf_t = email.scan(/The Conference ID for this event is:.*?(\d{4})./)
          result = presenter_conf_t[0][0]
          puts "Mandrill api - get email data - presenter conf id\t\t=> #{result.to_s}\n"
          result = presenter_conf_t[0][0]
        end
      when 'phone-number'
        begin
          #puts "email body decoded: " + email.body.decoded.to_s
          phone_t = email.scan(/\W*([0-9][0-9][0-9])\W*([0-9][0-9]{2})\W*([0-9]{4})(\se?x?t?(\d*))?/)
          result = phone_t.fetch(0).join
          puts "Mandrill api - get email data - phone number\t\t=> #{result.to_s}\n"
          result = phone_t.fetch(0).join
        end
      else
        puts "what parameter should match some of these words: permalink-url, pin, phone-number"
    end

  end
  def self.get_string_from_email_body (username,subject,what)
    email_info = nil
    email_content = ''
    #set up mandrill api
    data = API_Common.get_mandrill_data
    api_key =  get_mandrill_key_data('search_api_key')
    mandrill = Mandrill::API.new api_key
    #get mandrill emails
    send_api_keys = get_mandrill_key_data('send_api_keys')
    beginning_time = Time.now
    success = false
    puts "Start Waiting for Mandril to get Email Content #{ beginning_time}"
    until success  #wait until mandrill API is able to generate the the mail content
      begin
        while email_info.nil?  #wait until the email info is available
          begin
            sleep 3 #refresh time to not overload the server with massive gets
            emails = search_email_by_recipient(mandrill, data, send_api_keys, username)
            #serach for a specific email id
            email_info= get_email_info_by_subject(emails, username, subject) #+'@'+data['recipient_mail_server'],subject)
          end
        end
        #get the email content
        email_id = email_info['_id']
        mandrill.messages.info email_id
        email_content = mandrill_content(mandrill, data, email_id)
        success = true
      rescue Mandrill::Error => e
        begin
          # Mandrill errors are thrown as exceptions
          # only for debug  - puts "A mandrill error occurred: #{e.class} - #{e.message}"
          success = false
        end
      end
    end
    end_time = Time.now
    puts "Time elapsed to get email content from mandrill #{(end_time - beginning_time)*1000} milliseconds"
    #search and return the 'what' into the html content of the email
    result =  get_email_data( email_content['html'], what)
  end
end