require_relative '../support/helper/summon_api_admin_location'

When(/^I access the report api with  "(.*?)"$/) do |arg1|
  puts Reporting_API_Client.report_api(arg1)
end
Then(/^I request the report with  an invalid rest method "([^"]*)","([^"]*)"$/) do |arg1,arg2|
  puts Reporting_API_Client.report_api_invalid_method(arg1,arg2)
end
Then(/^I request the report from an invalid  uri$/) do
  puts Reporting_API_Client.report_api_invalid_uri
end
Then(/^I request the report with an invalid private key  "([^"]*)"$/) do |arg|
  puts Reporting_API_Client.report_api_invalid_key(arg,'private')
end
Then(/^I request the report with an invalid public key "([^"]*)"$/) do |arg|
  puts Reporting_API_Client.report_api_invalid_key(arg,'public')
end
Then(/^I request the report with an invalid public key "([^"]*)" as header$/) do |arg|
  puts Reporting_API_Client.report_api_header_invalid_key(arg)
end
Then(/^I request a report from another user$/) do
  puts Reporting_API_Client.report_api_no_access
end
Then(/^I request the report with an invalid mediaID "([^"]*)"$/) do |arg|
  puts Reporting_API_Client.report_api_invalid_media_id(arg)
end
Then(/^I request the report with the public key as the private key and the private key as the public key$/) do
  puts Reporting_API_Client.report_api_change_key
end
Then(/^I try to access the report after signature time out$/) do
  puts Reporting_API_Client.report_api_time_out
end
Then(/^I request the report with an misspelled "([^"]*)"$/) do |arg|
  puts Reporting_API_Client.report_api_misspelled(arg)
end