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
require_relative  '../helper/summon_api'

class Summon_Access_Line_Pool
  include DataMagic

  @@access_line_id = Array.new

  def self.get_country_details(search_value, field_name,json_details)
    json_result=Yajl::Parser.parse(json_details.to_json)
    json_result=Yajl::Parser.parse(json_result)
    result =''
    json_result.each do |country|
      result = country
      break if (country[field_name]==search_value)
    end
    result
  end

  def self.get_country_details_by_country_culture(country_culture,json_details)
    json_result=Yajl::Parser.parse(json_details.to_json)
    json_result=Yajl::Parser.parse(json_result)
    result =''
    json_result.each do |country|
      result = country
      if  country_culture == 'USCA'
        break if (country['name']=='US / Canada')   #special case hardcoded into summon
      else
        break if (country['cultureCode']==country_culture)
      end
    end
    result
  end

  def self.access_line_pool_post(country_culture_code,is_toll_free,carrier, termination_ip,json_details)
    country_details = get_country_details_by_country_culture(country_culture_code,json_details)
    country_id = country_details['countryId']
    country_code = country_details['code']
    country_name = country_details['name']
    date=  Time.new
    number = phone_number_generator(country_code.to_s)
    array_countries_int_code = Summon_API_Client.get_summon_api_countries_int_code_needed

    if array_countries_int_code.include?(country_name)
      phone_number_creation_params = country_code.to_s+number.to_s+'/'+country_id.to_s+'/'+is_toll_free.to_s+'/'+carrier.to_s+'/'+date.strftime("%Y-%m-%d")+'/'+termination_ip
    else
      phone_number_creation_params = number.to_s+'/'+country_id.to_s+'/'+is_toll_free.to_s+'/'+carrier.to_s+'/'+date.strftime("%Y-%m-%d")+'/'+termination_ip
    end
    puts "Create Params: #{phone_number_creation_params.to_s}"
    puts "Country: #{country_name.to_s}"
    puts "Country Code: #{country_code.to_s}"
    puts "Number to be added: #{number.to_s}"
    puts "Create should include country code?: #{(array_countries_int_code.include?(country_name)).to_s}"
    response = Summon_API_Client.request_summon_api_call('POST','public_key_admin','access_line_pool_post',phone_number_creation_params)#execute_summon_call('POST','public_key_admin','access_line_pool_post',phone_number_creation_params)
    json_result=after_summon_call(response)
    @@access_line_id.push(json_result[0]['accessLinesId'].to_s)
    rescue => e  #rest issue
      begin
        message = e.response.to_s
        re_do(message,country_culture_code,is_toll_free,carrier, termination_ip, number,json_details)
      end
  end
  def self.access_line_pool_delete
    response = ''
    @@access_line_id.each  do |number|
      puts "Deleting Access line#{number}"
      #response = execute_summon_call('DELETE','public_key_admin','access_line_pool_delete',number.to_s)
      response = Summon_API_Client.request_summon_api_call('DELETE','public_key_admin','access_line_pool_delete',number.to_s)
      after_summon_call(response)
    end
    @@access_line_id.clear
    rescue => e  #rest issue
      begin
        puts json_result.to_s
      end
  end

  def self.after_summon_call(response)
    prettify_response = JSON.pretty_generate(JSON.parse(response.body.to_s))
    result =  'Response code: '+response.code.to_s+'<br>'+'Server Response'+'<br>'+'<pre>'+prettify_response+'</pre>'
    puts "\n"
    puts result
    json_result=Yajl::Parser.parse(response.body.to_s)
    puts json_result.to_s
    json_result
  end
  def self.re_do(error_message,country_culture_code,is_toll_free,carrier, termination_ip, number,json_details)
    result =  error_message
    puts '\n'
    puts result
    json_result=Yajl::Parser.parse(result)
    if (json_result["resultCode"]='1006') # number is already on pool
      puts 'already on pool number '+number.to_s+' - Calling method again '
      result = access_line_pool_post(country_culture_code,is_toll_free,carrier, termination_ip,json_details)
    else
      fail
    end
  end

  def self.access_line_pool_custom_delete(accessLines_id)
    puts 'Deleting Access line' + accessLines_id
  end

  def self.phone_number_generator(country_code)
    code =''
    case country_code
      when '54' #Argentina
      begin
        code = rand(10**10)
        while code.to_s.length != 10
          code =rand(11**11)
        end
      end
      when '1'#US or CANADA
        begin
          code = rand(10**10)
          while code.to_s.length != 10
            code =rand(11**11)
          end
        end
      when '44'#UK
        begin
          code = rand(10**10)
          while code.to_s.length != 10
            code =rand(11**11)
          end
        end
      when '46'#SE
        begin
          code = rand(10**10)
          while code.to_s.length != 10
            code =rand(11**11)
          end
        end
      when '49'#DE
        begin
          code = rand(11**11)
          while code.to_s.length != 11
            code =rand(12**12)
          end
        end
      when '7'#RUSSIA
        begin
          code = rand(10**10)
          while code.to_s.length != 10
            code =rand(11**11)
          end
        end
    end
    result =  code
  end

  def self.access_line_pool_create(country_culture,carrier,tollfree,quantity,termination_ip,json_details)
    for i in 1..quantity.to_i
      access_line_pool_post(country_culture,tollfree,carrier,termination_ip,json_details)
    end
  end
end
