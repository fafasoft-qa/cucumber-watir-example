
Then(/^I request the access line from the host "([^"]*)"$/) do |arg|
  on_page(Access_Line_Telephony_API).access_line_get_host(arg)
end
Then(/^I request to create line with empty data$/) do
  on_page(Access_Line_Telephony_API).access_line_post_empty_data
end
Then(/^I request to create line with a wrong api key "([^"]*)"$/) do |arg|
  pending
end
Then(/^I request to create line authenticated as "([^"]*)"$/) do |arg|
  pending
end
Then(/^I request to create line authenticated with invalid host id$/) do
  pending
end
Then(/^I request to create line authenticated with invalid country id$/) do
  pending
end
Then(/^I request to create line authenticated with invalid promptSet id$/) do
  pending
end
Then(/^I request to create line authenticated with invalid user id$/) do
  pending
end
Then(/^I request to create line authenticated without sending parameters$/) do
  pending
end

Then(/^I request the access line from the line id "([^"]*)"$/) do |arg|
  on_page(Access_Line_Telephony_API).access_line_get_access(arg)
end
Then(/^I request to delete line from the line id "([^"]*)"$/) do |arg|
  on_page(Access_Line_Telephony_API).access_line_delete(arg)
end
Then(/^I request to create line with "([^"]*)","([^"]*)","([^"]*)","([^"]*)","([^"]*)"$/) do |hostId,countryId,promptSet,userTypeId,isTollFree|
  on_page(Access_Line_Telephony_API).access_line_post(hostId,countryId,promptSet,userTypeId,isTollFree)
end
Then(/^I request to update the prompset "([^"]*)" from the line id "([^"]*)"$/) do |prompset, accessLinesId|
  on_page(Access_Line_Telephony_API).access_line_put(accessLinesId, promptset)
end
Then(/^I request details of a conference given a "([^"]*)"$/) do |arg|
  on_page(Conference_Telephony_API).conference_get(conference_id)
end
Then(/^I request to update the conference data given  the conference id "([^"]*)" with  "([^"]*)","([^"]*)","([^"]*)"$/) do |valid_conference_id , recordingEnabled , registrationEnabled , conference_seats |
  on_page(Conference_Telephony_API).conference_put(valid_conference_id , recordingEnabled , registrationEnabled , conference_seats )
end
Then(/^I delete a number from the pool$/) do
  runtime_env_type = FigNewton.env_type
  if runtime_env_type != 'prod'
    Summon_Access_Line_Pool.access_line_pool_delete
  end
end
When(/^I add a number to the pool using country culture code "([^"]*)"$/) do |arg|
  json_details =  Summon_Location.get_details
  Summon_Access_Line_Pool.access_line_pool_post(arg,'false','level3ams', '127.0.0.1',json_details)
end
When(/^I add a number to the pool using "([^"]*)","([^"]*)","([^"]*)","([^"]*)","([^"]*)"$/) do |country_culture,carrier,tollfree,quantity,termination_ip|
  json_details =  Summon_Location.get_details
  Summon_Access_Line_Pool.access_line_pool_create(country_culture,carrier,tollfree,quantity,termination_ip,json_details)
end