#!/usr/bin/ruby
require 'rubygems'
require 'watir-webdriver'
require 'gmail'
require 'yaml' # Built in, no gem required
require_relative '../helper/common'
require_relative '../helper/mandrill_api'
require_relative  '../helper/api_common'
module AccountCreationHelper
  include DataMagic
  def self.yaml_to_file (new_account)
    data = YAML.load_file Dir.pwd+'/config/data/created_accounts.yml' #DataMagic.data_for(, data)
    data['accounts']['created_accounts'].push new_account
    File.open(Dir.pwd+'/config/data/created_accounts.yml', 'w') {|f| f.write data.to_yaml } #Store
  end
  def self.clean_up_account_files
    yaml_file = YAML.load_file Dir.pwd+'/config/data/login_data.yml'
    yaml_file["auto_created_account"]["username"] = ''
    File.open(Dir.pwd+'/config/data/login_data.yml', 'w') { |f| YAML.dump(yaml_file, f) }
    array_a = Array.new
    array_a.push "test"
    data = YAML.load_file Dir.pwd+'/config/data/created_accounts.yml' #DataMagic.data_for(, data)
    data['accounts']['created_accounts']= array_a
    File.open(Dir.pwd+'/config/data/created_accounts.yml', 'w') {|f| f.write data.to_yaml } #Store
  end
  def self.name_generator
    name = Time.now.utc.strftime('%Y%m%dT%H%M%S').to_s
  end
  def self.create_account
    DataMagic.load('account_creation.yml') #Load
    data={}
    DataMagic.data_for(:default_create_client_data, data)
    mail_sufix='@test.com'
    name = Time.now.utc.strftime('%d%b%Y%T').to_s
    email = name+mail_sufix
    password =data['password']
    reseller = data['reseller']
    client = data['client']
    return email
  end
  def self.get_last_created_account
    data = YAML.load_file Dir.pwd+'/config/data/created_accounts.yml'
    data['accounts']['created_accounts'].last
  end
end

