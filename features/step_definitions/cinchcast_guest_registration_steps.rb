require_relative '../support/helper/common'
require_relative '../support/helper/registration_api'

Given /^I am on Guest Registration Page$/ do
  event_title = $event_title
  Common.wait_for_new_window(@browser, event_title, 30)
	on_page(StudioPage).attach_to_window(:title => "#{event_title}")
  on_page(RegistrationPage).on_registration
  #on_page(RegistrationPage).clearmailbox
end

When /^I enter guest email address$/ do
  event_title = $event_title
  Common.wait_for_new_window(@browser, event_title, 30)
  on_page(StudioPage).attach_to_window(:title => "#{event_title}")
  on_page(RegistrationPage).add_email(Common.get_test_data("default.yml","guest_email", "email"))
end

When /^I see event description on Guest Registration Page$/ do
	on_page(RegistrationPage).check_registration_description(Common.get_test_data("default.yml","event_form_data", "description"))
end

Then /I see event description on Permalink Page$/ do
  on_page(RegistrationPage).check_registration_description(Common.get_test_data("default.yml","event_form_data", "description"))
end

When /^I see custom registration description on Guest Registration Page$/ do
  on_page(RegistrationPage).check_registration_description(Common.get_test_data("default.yml","event_form_data", "custom_registration_description"))
end

Then /^I see custom registration description on Permalink Page$/ do
  on_page(RegistrationPage).check_registration_description(Common.get_test_data("default.yml","event_form_data", "custom_registration_description"))
end

When /^I enter my email address as "(.*?)"$/ do |email|
  on_page(RegistrationPage).add_email(email)
end

When /^I Submit Registration$/ do
	on_page(RegistrationPage).submit_registration
end

Then /^I have succesfully registered for the upcoming event$/ do
  on_page(RegistrationPage).registration_confirmation
  $total_reg = $total_reg+1
  event_title = $event_title
  @browser.window(:title => "#{event_title}").close
end

Then /^I see message warning about domain is not allowed$/ do
  fail unless on_page(RegistrationPage).error_event_access_element.when_present(timeout=30).text.include? Common.get_test_data("default.yml","event_form_data", "registration_restriction_message")
end

Then /^I have succesfully registered for the archived event$/ do
	on_page(RegistrationPage).registration_confirmation_archived
  event_title = $event_title
	@browser.window(:title => "#{event_title}").close
end

When /^I go to the permalink from guest email$/ do
  permalinkURL = on_page(RegistrationPage).get_guest_permalink("You have successfully registered for #{$event_title}")
  # This following if statement is needed to keep coherence but needs to be improved because attended count is increased with call OR web for same guest
  if $current_feature_name.include? "reporting"
    on_page(RegistrationPage).increase_total_attend
  end
  puts "EVENT TITLE\t\t=> #{$event_title.to_s}\n"
  puts "PERMALINK URL\t\t=> #{permalinkURL.to_s}\n"
  @browser.execute_script("window.open('http://google.com')")
  Common.wait_for_new_window(@browser, 'Google', 30)
  on_page(RegistrationPage).attach_to_window(:title => 'Google')
  sleep 2
  @browser.goto(permalinkURL)
end

When /^I go to the studio from presenter email$/ do
  studioURL = on_page(RegistrationPage).get_presenter_studio_access_link("You have been made a Presenter for the event #{$event_title}")
  puts "EVENT TITLE\t\t=> #{$event_title.to_s}\n"
  puts "STUDIO URL\t\t=> #{studioURL.to_s}\n"
  @browser.execute_script("window.open('http://google.com')")
  Common.wait_for_new_window(@browser, 'Google', 30)
  on_page(RegistrationPage).attach_to_window(:title => 'Google')
  sleep 2
  @browser.goto(studioURL)
end

When(/^I go to the permalink from api email$/) do
  permalinkURL = Registration_API.get_guest_permalink("You have successfully registered for #{$event_title}")
  on_page(RegistrationPage).increase_total_attend
  puts "EVENT TITLE\t\t=> #{$event_title.to_s}\n"
  puts "PERMALINK URL\t\t=> #{permalinkURL.to_s}\n"
  @browser.execute_script("window.open('http://google.com')")
  Common.wait_for_new_window(@browser, 'Google', 30)
  on_page(RegistrationPage).attach_to_window(:title => 'Google')
  sleep 2
  @browser.goto(permalinkURL)
end
