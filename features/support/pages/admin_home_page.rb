#!/usr/bin/ruby
require 'rubygems'
require 'watir-webdriver'
require_relative '../helper/common'

class AdminHomePage
  #Using libraries
  include PageObject
  include DataMagic

  #Base URL - Extracted from environments/default.yml
  page_url(FigNewton.admin_url)

  text_field(:username, :id => 'UserName')
  text_field(:password, :id => 'Password')
  button(:sign_in, :id => 'btnLogin')
  span(:accounts_tab, :css => 'ul.nav li[ng-class*=account] span')
  text_field(:search_textbox, :id => 'search-term-textbox')
  button(:phone_numbers_button, :css => 'div.actions a.btn[href*=phonenumbers]')
  button(:add_phone_number, :css => 'div.box-header a.btn[href*=addphone]')
  button(:clients, :css => 'div.actions.admin-list-actions a.btn.small[href*=resellerclients]')
  button(:add_account, :css => 'div.actions.admin-list-actions a.btn.small[href*=addaccount]')
  li(:results_list, :css => 'li.ng-scope')
  a(:username_combobox, :id => 'username')
  text_field(:reseller_list, :css => 'span.title.ng-binding')

  def click_on_edit_button(index)
    @browser.element(:css => '.content-item:nth-of-type(' + (index+3).to_s + ') div.actions').link.click
  end

  def return_phone_numbers_list
    numbers_strings = []
    phone_numbers = @browser.elements(:css => '.content-item span.ng-binding:nth-of-type(1)')
    phone_numbers.each do |phone_number|
      numbers_strings << phone_number.text
    end
    return numbers_strings
  end

  def return_edit_phone_number_buttons
    return @browser.elements(:css => '.content-item a.btn.small.edit')
  end

  def return_new_number(numbers_before, numbers_after)
    new_number = ''
    numbers_after.each do |num1|
      number_present = false
      numbers_before.each do |num2|
        if num1 == num2
          number_present = true
          break
        end
      end
      if number_present == false
        new_number = num1
      end
    end
    return new_number
  end

  def find_phone_number_to_disassociate(number_to_disassociate)
    numnbers_list = return_phone_numbers_list
    edit_buttons = return_edit_phone_number_buttons
    numnbers_list.each_with_index do |number,index|
      if number.include? number_to_disassociate
        edit_buttons[index].click
        break
      end
    end
  end

  def go_to_admin_page
    @browser.goto FigNewton.admin_url
  end

  def check_results_list
    fail unless results_list_element.when_present(timeout = 120).visible?
  end

  #Using DataMagic, fill in login form with valid data from default.yml in config/data/
  def login_success(data = {})
    populate_page_with $login_data
    puts "USERNAME\t\t=> #{$login_data['username'].to_s}\n"
    sign_in
    sleep 5
  end

  def go_to_accounts_view
    accounts_tab_element.when_present(timeout = 60).click
  end

  def search_for_current_account
    search_for_account = username_combobox_element.text
    search_textbox_element.when_present.send_keys(search_for_account)
    sleep 2
  end
  def search_last_created_account
    DataMagic.load('login_data.yml')
    data = data_for(:auto_created_account,{})
    search_textbox_element.when_present.send_keys(data['username'])
    sleep 2
    return "LAST CREATED ACCOUNT => #{data['username']}\n"
  end

  def select_country(country)
    country_combobox_element.when_present(timeout = 30).select(country)
  end

  def select_prompt_set(prompt_set)
    prompt_set_combobox_element.when_present(timeout = 30).select(prompt_set)
  end

  def select_line_type(line_type)
    line_type_combobox_element.when_present(timeout = 30).select(line_type)
  end

  def create_account_for_custom
    data = get_acc_create_data_custom
    go_to_create_account_page(data)
  end

  def create_account_for_default ()
    data = get_acc_create_data_default
    go_to_create_account_page(data)
  end

  def go_to_create_account_page(data)
    reseller_name =  data['reseller']
    client_name =  data['client']
    search_textbox_element.when_present.send_keys(reseller_name)
    sleep 5
    check_results_list
    clients_element.when_present(timeout=30).fire_event('onClick')
    search_textbox_element.when_present(timeout=30).send_keys(client_name)
    sleep 5
    check_results_list
    add_account_element.when_present(timeout=30).fire_event('onClick')
    sleep 10
  end

  def get_acc_create_data_default(data={})
    DataMagic.load('account_creation.yml')
    DataMagic.data_for(:default_create_client_data, data)
  end

  def get_acc_create_data_custom(data={})
    DataMagic.load('account_creation.yml')
    DataMagic.data_for(:custom_create_client_data, data)
  end
end