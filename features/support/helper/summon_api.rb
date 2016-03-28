#!/usr/bin/env ruby
require 'rest_client'
require 'base64'
require 'openssl'
require 'rubygems'
require 'watir-webdriver'
require 'yajl'
require 'uri'
require_relative '../helper/common'

class Summon_API_Client
  include DataMagic

  def self.get_user_data (data = {})
    #runtime_env = FigNewton.env
    DataMagic.load('default.yml')
    env_prefix  = FigNewton.env_prefix
    DataMagic.data_for('default/'+env_prefix+'_summon_api_data', data)
  end

  def self.get_summon_api_data (data = {})
    DataMagic.load('summon_api.yml')
    summon_api_env = FigNewton.summon_api_env
    case summon_api_env
      when 'cb-api-dev-01.sip.blogtalkradio.com'
        DataMagic.data_for('summon_api/dev_telephony_api_data', data)
      when 'cb-api-qa.sip.blogtalkradio.com'
        DataMagic.data_for('summon_api/qa_telephony_api_data', data)
      when 'cb-api.sip.blogtalkradio.com'
        DataMagic.data_for('summon_api/prod_telephony_api_data', data)
      else
        fail 'environment variable did not match expected value'
    end
  end

  def self.call(call_as, phone_number, conf_id, pin)
    data = nil
    data = {}
    data = get_user_data
    decoded_uri_string = nil
    uri_string = nil
    decoded_uri_string = ""
    uri_string = ""
    if call_as == 'host'
      decoded_uri_string = decoded_uri_string << data['uri'] << call_as << '/'<< phone_number  << '@' << data['sip_ams'] << '/sleep:10000|dtmf:' << pin << '|sleep:10000|dtmf:1|sleep:10000|dtmf:' << conf_id << '|sleep:30000|speak:' << call_as << '+call?api_key=' << data['admin_key']
    else
      decoded_uri_string = decoded_uri_string << data['uri'] << call_as << '/'<< phone_number  << '@' << data['sip_ams'] << '/sleep:10000|dtmf:' << conf_id << '|sleep:10000|dtmf:' << pin << '|sleep:30000|speak:' << call_as << '+call?api_key=' << data['admin_key']
    end
    #puts "decoded uri string for " + call_as.to_s + ": " + decoded_uri_string.to_s
    uri_string = URI.encode(decoded_uri_string)
    puts "calling uri: #{uri_string}"
    begin
    RestClient.post uri_string,' '
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace.join("\n")
    end
  end

  def self.execute_post_call(uri,public_key )
    uri= uri+'?api_key='+public_key
    puts "\nSummon api - Execute post call - URI\t\t=> #{uri.to_s}\n"
    response = RestClient.post uri,''
  end

  def self.execute_delete_call(uri, public_key )
    response = RestClient.delete uri,{'api_key' => public_key}
  end
  def self.execute_get_call(uri, public_key )
    response = RestClient.get uri,{'api_key' => public_key }
  end

  def self.execute_summon_api_call (method_verb, uri,public_key, json_data)
    case method_verb
      when 'POST'
        response = execute_post_call(uri,public_key)
      when 'DELETE'
        response = execute_delete_call(uri,public_key)
      when 'GET'
        response = execute_get_call(uri,public_key)
    end
  end

  def self.request_summon_api_call(method,key_type,uri_parameters,query_string)
    data = get_summon_api_data
    url_parameters=   data[uri_parameters]+ query_string
    uri = data['uri']+ url_parameters
    public_key_admin = data[key_type]
    response = execute_summon_api_call(method, uri, public_key_admin,'')
  end

  def self.get_summon_api_countries_int_code_needed()
    data = get_summon_api_data
    array_countries_int_code=   data['countries_culture_code_with_int_code']
  end
end