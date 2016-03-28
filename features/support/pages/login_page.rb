#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'

class LoginPage

  #Using libraries
  include PageObject
  include DataMagic

  #Base URL - Extracted from environments/default.yml
  page_url(FigNewton.env)

  #Web-elements found in Login Page
  text_field(:username, :id => 'UserName')
  text_field(:password, :id => 'Password')
  button(:sign_in, :id => 'btnLogin')
  text_field(:username_fail, :id => 'UserName', :class => 'input-validation-error')
  text_field(:password_fail, :id => 'Password', :class => 'input-validation-error')
  checkbox(:stage_enable, :id => 'stagingEnabled')

  #Fill in login form with valid data from $login_data in features/support/hooks.rb
  def login_success(data = {})
    use_created_account = YAML.load_file Dir.pwd+'/config/data/default.yml'
    if  use_created_account['use_auto_created_account']
      DataMagic.load('login_data.yml')
      populate_page_with data_for(:auto_created_account,{})
    else
      populate_page_with data
    end
    puts "USERNAME\t\t=> #{$login_data['username'].to_s}\n"
    sign_in
    sleep 5
  end

  #Fill in login form with just created new account
  def login_with_just_created_account
    DataMagic.load('login_data.yml')
    populate_page_with data_for(:auto_created_account,{})
    created_username = AccountCreationHelper.get_last_created_account
    puts "USERNAME\t\t=> #{created_username.to_s}\n"
    sign_in
    sleep 5
  end

  #Using DataMagic, fill in login form with no username from default.yml in config/data/
  def no_username(data = {})
    DataMagic.load('default.yml')
    populate_page_with data_for(:login_no_username, data)
    sign_in
  end

  #Using DataMagic, fill in login form with no password from default.yml in config/data/
  def no_password(data = {})
    DataMagic.load('default.yml')
    populate_page_with data_for(:login_no_password, data)
    sign_in
  end

  #Using DataMagic, fill in login form with invalid data from default.yml in config/data/
  def incorrect_login(data = {})
    DataMagic.load('default.yml')
    populate_page_with data_for(:login_incorrect, data)
    sign_in
  end

  #Asserts that the error container is visible
  def login_fail
    fail unless @browser.div(:class => "validation-summary-errors").exists?
  end    

  #Using parameters entered by user in method call, login with that data.
  def login(username,password)
    self.username = username
    self.password = password
  end

  #Checks if the main content panel from Dashboard is visible.
  #This method should be found in Home)page.rb since it checks for the existance of an element in that page.
  def check_login
    fail unless @browser.div(:id => 'maincontent').exists?
  end

  #Is username red-bordered after failed to log in
  def check_username_fail
    fail unless username_fail?
  end

  #Is password red-boarded after failed to log in
  def check_password_fail
    fail unless password_fail?
  end

  #To enable staging environments
  def enable_staging
    @browser.goto FigNewton.staging_env
    check_stage_enable
    fail unless stage_enable_checked?
  end
  #To enable wl staging environments
  def wl_enable_staging
    @browser.goto FigNewton.wl_staging_env
    check_stage_enable
    fail unless stage_enable_checked?
  end
end
