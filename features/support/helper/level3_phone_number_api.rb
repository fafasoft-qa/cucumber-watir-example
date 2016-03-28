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
require_relative  '../helper/api_common'
require_relative '../helper/common'
require 'net/http'
class Level3PhoneNumberCustomError < StandardError
end

module Level3_API_Phone_Number_Client
  include PageObject
  include DataMagic

  def self.get_phone_details(country_code,phone_number,toll_type,user_type,expected_result)
     result = execute_api('phone', 'GET',country_code, phone_number,'',expected_result)
     json_answer=JSON.parse(result)[0]
     if expected_result.downcase !='fail'
       phone_number_validation = ''
       if  country_code.to_s == "1"
         phone_number_validation   = (country_code.to_s+phone_number.to_s).to_s
       else
         phone_number_validation   = phone_number.to_s
       end
       if json_answer['PhoneNumber'].to_s!= phone_number_validation
         fail(ArgumentError.new("returned [PhoneNumber]=[#{json_answer['PhoneNumber']}] is not the expected value [#{phone_number_validation.to_s}]  #{result}"))
       end

       if json_answer['CountryCode'].to_s!= country_code.to_s
         fail(ArgumentError.new("returned [CountryCode]=[#{json_answer['CountryCode']}] is not the expected value [#{country_code.to_s}]   #{result}"))
       end
       if json_answer['IsTollFree'].to_s!= toll_type.to_s
         fail(ArgumentError.new("returned [IsTollFree]=[#{json_answer['IsTollFree']}] is not the expected value [#{toll_type.to_s}] #{result}"))
       end
       #if json_answer['UserTypeId'].to_s!= user_type.to_s
         #fail(ArgumentError.new("returned [UserTypeId]=[#{json_answer['UserTypeId']}] is not the expected #{ user_type.to_s} #{result}"))
       #end
     end
     return result
  end
  def self.get_details_per_carrier(carrier_name,expected_result)
    result =  execute_api('carrier', 'GET','', '',carrier_name,expected_result)
    if result.code!=200 and expected_result.downcase !='fail'
      fail(ArgumentError.new("Server response is not 200 for carrier #{carrier_name}:  #{result}"))
    end
    return result
  end
  def self.execute_api(api_method, verb,country_code, phone_number,carrier_name,expected_result)
    data =  API_Common.get_level3_api_user_data
    uri =''
    account = data['account_1']
    private_key = data['secret_key_1']
    public_key  = data['public_key_1']
    case api_method.downcase
      when 'phone'
        uri = 'https://'+FigNewton.env+data['details_by_phone']+country_code.to_s+'/'+phone_number.to_s
      when 'carrier'
        uri = 'https://'+FigNewton.env+data['details_by_carrier']+carrier_name
      else
    end

    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    signature = API_Common.calculate_hash(private_key,verb,uri,time)# calculate(private_key, verb, uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    puts "Level3 phone number api -    Public key\t\t=> #{public_key.to_s}\n"
    puts "Level3 phone number api -   Private key\t\t=> #{private_key.to_s}\n"
    puts "Level3 phone number api -       Account\t\t=> #{account.to_s}\n"
    puts "Level3 phone number api -           URI\t\t=> #{uri.to_s}\n"
    puts "Level3 phone number api - Authorization\t\t=> #{authorization.to_s}\n"
    puts "Level3 phone number api -          Time\t\t=> #{time.to_s}\n"

    result =  API_Common.request_external_api_get(uri,authorization,time)
    return  result
    rescue => e  #rest issue
      begin
          result = get_error_message(e)
          fail(ArgumentError.new(result)) if expected_result.downcase !='fail'
          return result
      end
  end
  def self.get_error_message(e)
    e.response!=nil ? result = e.response.to_s : result = e.to_s
    return result
  end
end
