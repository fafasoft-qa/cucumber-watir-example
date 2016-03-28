#!/usr/bin/ruby
require 'rubygems'
require 'watir-webdriver'
require 'gmail'
require_relative '../helper/common'
require_relative '../helper/mandrill_api'
require_relative  '../helper/api_common'
module VerifyEmail

  def self.delete_all_emails(username, password)
    gmail =  Gmail.new(username,password)
     #delete all read emails
    gmail.inbox.emails(:read).each do |email|
      email.delete!
    end
     #delete all unread emails
    gmail.inbox.emails(:unread).each do |email|
      email.delete!
    end
    gmail.logout
  end
  def self.get_string_from_email_body(username, password, subject, what)
    data = API_Common.get_mandrill_data
    switch = data['switch']
    result = ''
    case switch
      when 'mandrill'
        begin
          result = Mandrill_API.get_string_from_email_body(username,subject,what)
        rescue StandardError=> e
             puts 'Mandrill Fails -  Trying Gmail'
            result = old_get_string_from_email_body(username, password, subject, what)
        end
      when 'gmail'
        begin
          result = old_get_string_from_email_body(username, password, subject, what)
        rescue StandardError=> e
          puts 'Gmail Fails -  Trying Mandrill'
          result = Mandrill_API.get_string_from_email_body(username,subject,what)
        end
      else
        puts 'Mail server was undefined -  please correct the data on mandrill_data.yml'
    end
  end
  def self.get_string_using_switch(username, password, subject, what)
    data = API_Common.get_mandrill_data
    switch = data['switch']
    case switch
      when 'mandrill'
        result = Mandrill_API.get_string_from_email_body(username,subject,what)
      when 'gmail'
        result = old_get_string_from_email_body(username, password, subject, what)
      else
        puts 'Mail server was undefined -  please correct the data on mandrill_data.yml'
    end

  end
  def self.old_get_string_from_email_body(username, password, subject, what)
    result = ''
    i = 1
    found = false
    gmail = Gmail.new(username,password)
    sleep 2
    while gmail.inbox.count < 1 do
      sleep 0.5
      i+=1
      if i > 100
        fail "No emails within 50 secs"
      end
    end

    # Validate if new email arrived to inbox
    email = gmail.inbox.emails.last
    j=0
    for j in 0..30
      email_sub =  email.subject
      if email_sub != subject
        puts "last GMAIL subject:#{email_sub} - Subject of the created event #{subject} - Fail"
        if j==30
          gmail.logout
          fail "Email not arrived to inbox after 5 minutes."
        end
      else
        puts "last GMAIL subject:#{email_sub} - Subject of the created event: #{subject} - Success"
        break
      end
      sleep 10
      email = gmail.inbox.emails.last
    end
    #puts "BODY DECODED: " + email.body.decoded
    email_sub =  email.subject
    puts "Registration Mail founded - subject: #{email_sub } - event created: #{subject}"
    #read email body and extract requested value according 'what' parameter
    case what
      when 'permalink-url'
        begin
          permalinkURL = email.body.decoded.scan(/at this url:<br\/><a href="((\w+:\/\/)[-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+\/ses\/.*?)" target="_blank">/)
          result = permalinkURL[0][0]
          puts "PERMALINK URL: " + result
        end
      when 'studio-url'
        begin
          studioURL = email.body.decoded.scan(/As a presenter you have been given authorization to manage the Studio during the event. You can do that at this url:<br\/><a href="([-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+\/studio\/.*?)" target="_blank">/)
          puts "STUDIO URL: " + result
          result = studioURL[0][0]
          puts "STUDIO URL: " + result
        end
      when 'guest-pin'
        begin
          guest_pin_t = email.body.decoded.scan(/<h3>(\d{7})<\/h3>/)
          result = guest_pin_t[0][0]
        end
      when 'presenter-pin'
        begin
          presenter_pin_t = email.body.decoded.scan(/Your PIN Number for this event is:.*?(\d{7})./)
          result = presenter_pin_t[0][0]
        end
      when 'guest-conf-id'
        begin
          guest_conf_t = email.body.decoded.scan(/<h3>(\d{4})<\/h3>/)
          result = guest_conf_t[0][0]
        end
      when 'presenter-conf-id'
        begin
          presenter_conf_t = email.body.decoded.scan(/The Conference ID for this event is:.*?(\d{4})./)
          result = presenter_conf_t[0][0]
        end
      when 'phone-number'
        begin
          #puts "email body decoded: " + email.body.decoded.to_s
          phone_t = email.body.decoded.scan(/\W*([0-9][0-9][0-9])\W*([0-9][0-9]{2})\W*([0-9]{4})(\se?x?t?(\d*))?/)
          result = phone_t.fetch(0).join
        end
      else
        puts "what parameter should match some of these words: permalink-url, pin, phone-number"
    end
    gmail.logout
    # waiting 5 sec until gmail logs out
    sleep 5
    return result
  end
end