#!/usr/bin/ruby

require_relative '../helper/verify_email'
require_relative '../helper/common'
require 'rubygems'
require 'watir-webdriver'

class RegistrationPage

  #Using libraries
  include PageObject
  include DataMagic
  include VerifyEmail

  #Web-elements found in Permalink Page
  div(:on_page, :id => 'maincontent')
  text_field(:email, :id => 'email')
  text_field(:firstname, :id => 'firstName')
  text_field(:lastname, :id => 'lastName')
  select(:country, :name => 'country')
  select(:state, :name => 'state')
  button(:register, :value => 'Register')
  div(:confirm, :class =>'description')
  div(:loading_bar, :class => 'progressbar animate')
  div(:error_event_access, :id => 'validation-error-event-access')
  p(:upcoming_registration_success_message, :css => 'div.row.registration-confirmation:nth-of-type(3) div.col-xs-12 p:nth-of-type(1)')
  p(:archived_registration_success_message, :css => 'div.row.registration-confirmation:nth-of-type(3) div.col-xs-12 p:nth-of-type(1)')
  p(:event_description, :css => 'div.description p')

  #Checks if maincontent panel in permalink page is present
  def on_registration
    sleep 5
    while @browser.text.include? "Loading"
      sleep 1
    end
    on_page?
  end

  #increases page view variable value
  def increase_page_view
    $reg_views = $reg_views+1
  end

  #returns page view variable value
  def return_page_view
    return $reg_views
  end

  #adds first name for guest registration
  def add_first_name(first)
    self.first = first
  end

  #adds last name for guest registration
  def add_last_name(last)
    self.last = last
  end

  #def add_country

  #end

  #def add_state

  #end

  #reset all counters
  def reset_count
    $reg_views = 0
    $total_reg = 0
    $total_attend = 0
    $reg_attend = 0
  end

  #add email to guest registration
  def add_email(email)
    self.email = email
  end

  #submit guest registration form
  def submit_registration
    register_element.click()
  end

  #returns total registration variable
  def total_registration
    return $total_reg
  end

  def check_registration_description(expected_description)
    fail unless event_description_element.when_present(timeout = 20).text == expected_description
  end

  #verifies guest registration confirmation is accurate
  def registration_confirmation
    while @browser.text.include? "Loading"
      sleep 2
    end
    fail unless upcoming_registration_success_message_element.when_present(timeout = 60).text.include? Common.get_test_data("default.yml","registration_data", "upcoming_reg_success_message")
  end

  #verifies guest registration for archived event is accurate
  def registration_confirmation_archived
    while @browser.text.include? "Loading"
      sleep 2
    end
    fail unless archived_registration_success_message_element.when_present(timeout = 60).text.include? Common.get_test_data("default.yml","registration_data", "archived_reg_success_message")
  end

  #get event permalink from guest registration email (using verify_email.rb)
  def get_guest_permalink(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml["guest_email"]
    permalinkURL =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'permalink-url')
  end

  #get event permalink from guest registration email (using verify_email.rb)
  def get_presenter_studio_access_link(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml["presenter_email"]
    permalinkURL =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'studio-url')
  end

  #get event pin from guest registration email (using verify_email.rb)
  def get_guest_pin(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml["guest_email"]
    pin =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'guest-pin')
  end

  #clear data in mailbox for guest registration account (using verify_email.rb)
  #def clearmailbox(data={})
  #  DataMagic.load('default.yml')
  #  data = DataMagic.yml["guest_email"]
  #  delete_all_emails(data["email"],data["password"])
  #end

  #get event permalink url from presenter registration email (using verify_email.rb)
  def get_presenter_permalink(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml["presenter_email"]
    permalinkURL =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'permalink-url')
  end

  #increase the variable of total attended
  def increase_total_attend
    $total_attend = $total_attend+1
  end

  #get event pin from presenter registration email (using verify_email.rb)
  def get_presenter_pin(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml['presenter_email']
    pin =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'presenter-pin')
  end

  #get conferenceId from presenter registration email (using verify_email.rb)
  def get_presenter_conference_id(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml['presenter_email']
    conference_id =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'presenter-conf-id')
  end

  #get conferenceId from guest registration email (using verify_email.rb)
  def get_guest_conference_id(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml["guest_email"]
    conference_id =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'guest-conf-id')
  end

  #total attended should be 0 when the show status is preshow, once live then the total attend count should be used
  def total_attended(status)
    case status
      when "preshow"
        return 0
      when "live"
        return $total_attend
      when "finished"
        return $total_attend
      else
    end
  end

  #clear data in mailbox for presenter registration account (using verify_email.rb)
  #def clearmailbox_presenter(data={})
  #  DataMagic.load('default.yml')
  #  data = DataMagic.yml["presenter_email"]
  #  delete_all_emails(data["email"],data["password"])
  #end

  #extract guest phone number from guest registration email (using verify_email.rb)
  def get_guest_phone(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml["guest_email"]
    phone_number =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'phone-number')
  end

  #extract presenter phone number from presenter registration email (using verify_email.rb)
  def get_presenter_phone(subject)
    DataMagic.load('default.yml')
    data = DataMagic.yml["presenter_email"]
    phone_number =  VerifyEmail.get_string_from_email_body(data["email"],data["password"],subject,'phone-number')
  end
end