#!/usr/bin/ruby
require 'rubygems'
require 'watir-webdriver'
require_relative '../helper/common'
require_relative '../helper/account_creation_helper'

class AccountCreation
  #Using libraries
  include PageObject
  include DataMagic
  button(:save, :css => 'a.btn.big.cta')
  text_field(:first_name, :css => 'input[ng-model=model\.account\.FirstName]')
  text_field(:last_name, :css => 'input[ng-model=model\.account\.LastName]')
  text_field(:display_name, :css => 'input[ng-model=model\.account\.DisplayName]')
  text_field(:email, :css => 'input[ng-model=model\.account\.Email]')
  text_field(:user_name, :xpath => "//input[@ng-model='model.account.UserName']")
  text_field(:user_url, :css => 'input[ng-model=model\.account\.UserUrl]')
  select_list(:time_zone, :css => "select[ng-model='selectedTimeZone']")
  label(:manual_password, :for => 'RadioPassFalse')
  text_field(:password_field, :id => 'password')

  def complete_account_form
    #Load  data
    mail_sufix='@qaams.com'
    name = AccountCreationHelper.name_generator
    email = name+mail_sufix
    data= get_data
    password =data['password']
    #complete form
    first_name_element.when_present(timeout = 30).send_keys(name)
    last_name_element.when_present(timeout = 30). send_keys(name)
    display_name_element.when_present(timeout = 30).send_keys(name)
    email_element.when_present(timeout = 30).send_keys(email)
    user_name_element.when_present(timeout = 30).send_keys(email)
    user_url_element.when_present(timeout = 30).send_keys(name)
    time_zone_element.when_present(timeout = 30).select_value("141")#new york
    #manual_password_element.when_present(timeout = 30).click
    @browser.label(:for => 'RadioPassFalse').when_present(timeout = 30).fire_event("click")
    sleep 2
    password_field_element.when_present(timeout = 30).send_keys(password)
    user_url_element.when_present(timeout = 30).send_keys(name)
    complete_cbc_data
    #save
    save_element.click
    #ToDo account creation valid verification
    AccountCreationHelper.yaml_to_file(email)
    created_account = AccountCreationHelper.get_last_created_account
    #update
    yaml_file = YAML.load_file Dir.pwd+'/config/data/login_data.yml'
    yaml_file["auto_created_account"]["username"] = created_account
    File.open(Dir.pwd+'/config/data/login_data.yml', 'w') { |f| YAML.dump(yaml_file, f) }
    return "CREATED ACCOUNT => #{created_account}"
  end

  def complete_cbc_data
      #cbcs = @browser.elements(:css => 'fieldset#basics-tab.tabcontent fieldset input[id^="ChargeBackCodeFields"][type=text]')
    cbcs = @browser.elements(:css => 'input[name^="chargeBackCode"]')
    cbcs.each do |e|
      e.to_subtype.send_keys('123456')
    end
  end

  def get_data(data={})
    DataMagic.load('account_creation.yml')
    DataMagic.data_for(:default_create_client_data, data)
  end
end