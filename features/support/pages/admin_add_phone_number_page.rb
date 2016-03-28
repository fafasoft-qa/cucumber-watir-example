#!/usr/bin/ruby
require 'rubygems'
require 'watir-webdriver'
require_relative '../helper/common'

class AdminAddPhoneNumberPage
  #Using libraries
  include PageObject
  include DataMagic

  li(:phones_list, :css => 'li.ng-scope')
  select_list(:country_combobox, :name => 'countries')
  select_list(:prompt_set_combobox, :name => 'PromptSets')
  select_list(:line_type_combobox, :name => 'LineType')
  button(:toll_free_true, :css => 'label[for="IsTollfree_true"]')
  button(:toll_free_false, :css => 'label[for="IsTollfree_false"]')
  button(:associate_number_save_button, :css => 'a.btn[ng-click*=save]')
  button(:disassociate_number_button, :css => 'a.btn[ng-click*=disassociate]')
  def disassociate_number
    disassociate_number_button
  end

  def disassociate_all_numbers
    numbers_strings = []
    phone_numbers = @browser.elements(:css => '.content-item span.ng-binding:nth-of-type(1)')
    phone_numbers.each do |phone_number|
      numbers_strings << phone_number.text
    end
    log_message = "HOST NUMBER => #{numbers_strings[0]} CANNOT BE DISASSOCIATED.\n\n"
    for index in 1..(numbers_strings.size-1)
      @browser.element(:css => 'a.btn.small.edit', :index => 1).when_present(timeout=60).click
      disassociate_number_button_element.when_present(timeout=60).click
      log_message << "DISASSOCIATED NUMBER => #{numbers_strings[index]}\n"
    end
    return log_message.to_s
  end

  def select_country(country)
    country_combobox_element.when_present(timeout = 30).select(country)
  end

  def select_prompt_set(promptset)
    prompt_set_combobox_element.when_present(timeout = 30).select(promptset)
  end

  def select_line_type(linetype)
    line_type_combobox_element.when_present(timeout = 30).select(linetype)
  end

  def associate_phone_number(country, prompt_set, line_type, toll_free)
    select_country(country)
    select_prompt_set(prompt_set)
    select_line_type(line_type)
    if toll_free == 'true'
      toll_free_true_element.click
    else
      toll_free_false_element.click
    end
    associate_number_save_button
  end
end