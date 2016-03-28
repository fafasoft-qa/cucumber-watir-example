Given(/^I go to Event Access page$/) do
  on_page(HomePage).go_event_access_page
end

Given /^I should be on Event Access page$/ do
  on_page(EventAccessPage).on_page
end

Given /^I remove all added domains$/ do
  on_page(EventAccessPage).remove_added_domains
end

Given /^I set "(.*?)" for "(.*?)" and save$/ do |domain_str, list_str|
  on_page(EventAccessPage).add_domain(domain_str)
  on_page(EventAccessPage).set_list(list_str)
  on_page(EventAccessPage).save_button_element.when_present(timeout = 30).click
end

Given /^I removed any event access restriction if exists$/ do
  on_page(HomePage).go_event_access_page
  on_page(EventAccessPage).on_page
  on_page(EventAccessPage).remove_added_domains
  on_page(EventAccessPage).save_button_element.when_present(timeout = 30).click
  on_page(HomePage).check_homepage
end





