require_relative '../support/helper/account_creation_helper'
When(/^I login into Admin page$/) do
  visit_page(AdminHomePage)
  on_page(AdminHomePage).login_success($login_data)
end

When(/^I go to Admin page$/) do
  on_page(AdminHomePage).go_to_admin_page
end

When(/^I go to Accounts view$/) do
  on_page(AdminHomePage).go_to_accounts_view
  on_page(AdminHomePage).check_results_list
end

When(/^I search for account for current user$/) do
  on_page(AdminHomePage).search_for_current_account
end

When(/^I search for account for last created user$/) do
  last_created_account = on_page(AdminHomePage).search_last_created_account
  puts last_created_account.to_s
end

When(/^I go to associated Phone Numbers view$/) do
  on_page(AdminHomePage).phone_numbers_button_element.when_present(timeout=30).fire_event('onClick')
  on_page(AdminHomePage).check_results_list
end

When(/^I go to Account form for the default reseller and client$/) do
  on_page(AdminHomePage).check_results_list
  on_page(AdminHomePage).create_account_for_default
end

When(/^I go to Account form for the custom reseller and client$/) do
  on_page(AdminHomePage).check_results_list
  on_page(AdminHomePage).create_account_for_custom
end

When(/^I add a new account for the default Client$/) do
  created_account = on_page(AccountCreation).complete_account_form
  puts created_account.to_s
  on_page(AdminHomePage).check_results_list #client list should be displayed after creation
end

When(/^I disassociate all phone numbers$/) do
  disassociated_numbers_output = on_page(AdminAddPhoneNumberPage).disassociate_all_numbers
  puts disassociated_numbers_output.to_s
end
When(/^I clean the list of created accounts$/) do
  AccountCreationHelper.clean_up_account_files
end