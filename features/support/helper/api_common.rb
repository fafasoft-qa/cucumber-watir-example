#!/usr/bin/ruby
#Helper class.
require 'rubygems'
require 'watir-webdriver'
require 'base64'
module API_Common

  include PageObject
  include DataMagic
  #################################Helper Functionalities##############################################
  def self.compare_jason(to_compare_json1,to_compare_json2)
    json1=Yajl::Parser.parse(to_compare_json1)
    json2=Yajl::Parser.parse(to_compare_json2)
    exclusion = ["errorId"]
    result = JsonCompare.get_diff(json1, json2,exclusion)
    fail unless result.empty?
  end
  def self.calculate_hash (private_key, verb, uri, time)
    data =  verb + "\n" + time + "\n" + uri
    hash  = OpenSSL::HMAC.digest('sha256', private_key, data)
    Base64.encode64(hash)
  end
  ####################################################################################################
  ################################Data retrieve from config files per API############################
  def self.get_reporting_api_user_data (data = {})
    DataMagic.load('reporting_api.yml')
    telephony_api_env_prefix = FigNewton.env_prefix
    DataMagic.data_for('reporting_api/'+telephony_api_env_prefix+'_reporting_api_data', data)
  end

  def self.get_level3_api_user_data (data = {})
    DataMagic.load('level3_phone_api_data.yml')
    runtime_env_type = FigNewton.env_type
    DataMagic.data_for('level3_phone_api_data/'+runtime_env_type, data)
  end

  def self.get_registration_api_data (data = {})
    DataMagic.load('registration_api.yml')
    DataMagic.data_for(:registration_api_data, data)
  end
  def self.get_mandrill_data (data = {})
    DataMagic.load('mandrill_data.yml')
    DataMagic.data_for(:mandrill_api_data, data)
  end
  ####################################################################################################
  #############################Api method Calls from EXTERNAL Clients to AMS #########################
  def self.request_external_api_get(uri,authorization, time )
    response = RestClient.get uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization, :ssl_version => 'SSLv23'}
    rescue => e
      response = RestClient.get uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end

  def self.request_external_api_post(uri,authorization, time )
    response = RestClient.post uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization, :ssl_version => 'SSLv23'}
  rescue => e
    response = RestClient.post uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end

  def self.request_external_api_put(uri,authorization, time )
    response = RestClient.put uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization, :ssl_version => 'SSLv23'}
  rescue => e
    response = RestClient.put uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end

  def self.request_external_api_delete(uri,authorization, time )
    response = RestClient.delete uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization, :ssl_version => 'SSLv23'}
  rescue => e
    response = RestClient.delete uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end
  ####################################################################################################
end