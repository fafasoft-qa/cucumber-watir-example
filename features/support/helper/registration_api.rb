#!/usr/bin/env ruby
require 'rest_client'
require 'base64'
require 'openssl'
require 'rubygems'
require 'watir-webdriver'
require 'yajl'
require 'json-compare'
require 'rspec/expectations'
require 'json'
require_relative '../helper/common'

class RegistrationAPICustomError < StandardError
end
class Registration_API

   #include DataMagic
    def self.request_registration_post (uri,payload)
      puts "Registration api - Request reg post - URI\t\t=> #{uri.to_s}\n"
      response = RestClient.post uri, payload,  :content_type => :json, :accept => :json, :ssl_version => 'SSLv23'
      rescue => _
        response = RestClient.post uri, payload,  :content_type => :json, :accept => :json
    end
    def self.create_payload(uri,email,ref_code,encrypted_id,options,form_data)
      #create options string
      v_email = 'Email'
      v_refCode = 'RefCode'
      v_encryptedId = 'EncryptedId'
      v_options = 'Options'
      v_formData = 'FormData'
      my_hash = {v_email=> email, v_refCode=> ref_code, v_encryptedId=> encrypted_id,
                 v_options=> {}, v_formData=> {}}
      options.each do |option|
        key = option.split('|')[0]
        value = option.split('|')[1]
        #my_hash.update(my_hash['Options']) do | |
        #  my_hash['Options'].merge(key => value)
        #end
        #my_hash.update(my_hash){|v_options,v|my_hash['Options'].merge(key => value)}
        my_hash['Options'] = my_hash['Options'].merge(key => value)
      end
      form_data.each do |f_data|
        key = f_data.split('|')[0]
        value = f_data.split('|')[1]
        #my_hash.update(my_hash) do | |
        #  my_hash['FormData'].merge(key => value)
        #end
        my_hash['FormData'] = my_hash['FormData'].merge(key => value)
      end
      json_payload = JSON.generate (my_hash)
    end
   def self.registration(encrypted_id)
      data = API_Common.get_registration_api_data
      email= data['email_prefix']+'@'+data['email_domain']
      response = registration_with_email(encrypted_id,email)
    end
    def self.registration_with_email(encrypted_id, email)
      data =  API_Common.get_registration_api_data
      form_data = data['form_data']
      options = data['options']
      ref_code = data['ref_code']
      DataMagic.load('default.yml')
      uri =  'https://'+ FigNewton.env + data['uri']
      json_payload =  create_payload(uri,email,ref_code,encrypted_id,options,form_data)
      puts "Registration api - Reg with email --------------- URI\t\t=> #{uri.to_s}\n"
      puts "Registration api - Reg with email - Email to register\t\t=> #{email.to_s}\n"
      puts "Registration api - Reg with email ------ JSON Payload\t\t=> #{json_payload.to_s}\n"
      response = request_registration_post(uri, json_payload)
    rescue StandardError=>e
      begin
        prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
        result =  'Response code: '+e.http_code.to_s+'<br>'
        result =  'Server Response: '+'<br>'
        result =  result + prettify_response+'<br>'
      end
    end
    def self.registration_load_test(encrypted_id, quantity)
      data = API_Common.get_registration_api_data
      email= data['email_prefix']+'@'+data['email_domain']
      for i in 1..quantity.to_i
        email= data['email_prefix']+'+'+i.to_s+'@'+data['email_domain']
        puts registration_with_email(encrypted_id,email)
      end
    end

    def self.get_guest_permalink(subject)
      data = API_Common.get_registration_api_data
      permalinkURL =  VerifyEmail.get_string_from_email_body(data["registration_email"],data["password"],subject,'permalink-url')
    end
end


