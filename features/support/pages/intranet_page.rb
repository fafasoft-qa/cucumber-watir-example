#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'

class IntranetPage
  #Using libraries
  include PageObject
  include DataMagic

  text_field(:link_text, :id => 'MarketingLinkText')
  text_field(:link_URL, :id => 'MarketingLinkUrl')
  button(:save_changes, :id => "iSaveAll")
  text_field(:client_by_id, :id => 'id')
  button(:go_by_id, :value => 'Go')
  link(:clients_dropdown, :id => 'clientslink')
  link(:email_pin_search_menu_link, :id => 'emailpinsearchlink')
  h1(:email_pin_page_title, :css => 'div.container:nth-of-type(2) h1')
  text_field(:email_pin_search_textbox, :id => 'search')
  table(:email_pin_search_results_table, :css => 'table.searches')
  label(:email_pin_search_no_results_message, :css => 'div.container label')

  #check to make sure on email pin search page
  def check_email_pin_search_page
    fail unless email_pin_page_title_element.when_present(timeout=30).text.include? "Connect Email/PIN Search"
  end

  def search_on_email_pin_search_page_by(by_word)
    data = {}
    runtime_env = FigNewton.env
    DataMagic.load('intranet_data.yml')
    case runtime_env
      when 'platform.cinchcast.com','prod.cwebcast.com'
        data = DataMagic.data_for(:prod_intranet_data, data)
      when 'qa-platform.cinchcast.com','qa.cwebcast.com'
        data = DataMagic.data_for(:qa_intranet_data, data)
      when 'qa2-platform.cinchcast.com'
        data = DataMagic.data_for(:qa2_intranet_data, data)
      when 'qa3-platform.cinchcast.com'
        data = DataMagic.data_for(:qa3_intranet_data, data)
      when 'dev-platform.cinchcast.com'
        data = DataMagic.data_for(:dev_intranet_data, data)
      when 'feature1-platform.cinchcast.com'
        data = DataMagic.data_for(:feature2_intranet_data, data)
      when 'feature2-platform.cinchcast.com'
        data = DataMagic.data_for(:feature2_intranet_data, data)
      when 'feature3-platform.cinchcast.com'
        data = DataMagic.data_for(:feature2_intranet_data, data)
      else
        fail 'environment variable did not match expected value'
    end
    email_pin_search_textbox_element.when_present.clear
    case by_word
      when "email"
        email_pin_search_textbox_element.send_keys(data['emailpinsearch_email'])
      when "pin"
        email_pin_search_textbox_element.send_keys(data['emailpinsearch_pin'])
      when "junk"
        email_pin_search_textbox_element.send_keys(data['emailpinsearch_junk'])
      else
        fail "By_word parameter is not valid"
    end
    @browser.send_keys :enter
    sleep 10
  end

  def email_pin_search_check_results_list
    fail unless email_pin_search_results_table_element.when_present(timeout = 30).visible?
  end

  def email_pin_search_check_no_results_message
    fail unless email_pin_search_no_results_message_element.when_present(timeout = 30).text.include? "No results to show."
  end

  def set_viral(link_text,link_URL)
    self.link_text = link_text
    self.link_URL = link_URL
    save_changes
  end

  def go_to_intranet
  	@browser.goto FigNewton.intranet
  end

  def go_to_clients(client_by_id)
    clients_dropdown
    self.client_by_id = client_by_id
    @browser.send_keys :enter
    #go_by_id_element.click
  end

  def go_to_email_pin_search
    email_pin_search_menu_link_element.click
  end

  def client_updated
    fail unless @browser.text.include? "Client updated"
  end
end