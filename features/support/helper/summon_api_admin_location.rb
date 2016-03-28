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

class Summon_Location
  def self.get_details
    response = Summon_API_Client.request_summon_api_call('GET','public_key_admin','location_details','')

  end
  def self.get_detail(country_id)
    response = Summon_API_Client.request_summon_api_call('GET','public_key_admin','location_detail',country_id)
  end
end