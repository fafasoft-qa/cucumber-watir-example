#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'
require 'watir-scroll'
require_relative '../helper/common'

class EventAccessPage
  #Using libraries
  include PageObject

  #Web-elements found in Event Access Page
  h1(:title, :css => 'div.box-header h1')
  text_field(:domain_textbox, :id => 'domainInput')
  button(:add_domain_button, :css => 'fieldset.box div.blockleft button.btn')
  label(:whitelist_button, :css => 'label[for="isWhiteList"]')
  label(:blacklist_button, :css => 'label[for="isBlackList"]')
  a(:cancel_button, :css => 'div.commit-buttons a.btndiv.commit-buttons a.btn')
  button(:save_button, :css => 'div.commit-buttons button.btn')
  td(:domain_list_values, :css => 'tr.ng-scope td.ng-binding')
  p(:successful_message, :css => 'div.settingsform div.alert p')
  span(:first_delete_icon, :css => 'tr.ng-scope:nth-of-type(1) td:nth-of-type(2) span')

  def on_page
    #sleep 5
    until title_element.exists? #@browser.text.include? "Loading"
      sleep 1
    end

    fail unless title_element.when_present(timeout=30).text.include? "Restrict access to events by email domain"
  end

  def add_domain(domain_str)
    remove_added_domains
    domain_textbox_element.when_present.send_keys(domain_str)
    blacklist_button_element.when_present(timeout = 20).click
    add_domain_button_element.when_present.click
  end

  def set_list(list)
    @browser.scroll.to :bottom
    sleep 1
    case list
      when "blacklist"
        blacklist_button_element.when_present.click
      when "whitelist"
        whitelist_button_element.when_present.click
      else
     end
  end

  def remove_added_domains()
    if FigNewton.browser =="chrome"
      Common.wait_until_ready('css','tr.ng-scope:nth-of-type(1) td:nth-of-type(2) span', "Remove domain icon",15)
    end
    @browser.scroll.to :bottom
    while (first_delete_icon_element.visible?) do
      sleep 1
      if FigNewton.browser =="chrome"
        Common.wait_until_ready('css','tr.ng-scope:nth-of-type(1) td:nth-of-type(2) span', "Remove domain icon",15)
      end
      first_delete_icon_element.click
      sleep 1
      @browser.scroll.to :bottom
    end
  end
end