require_relative '../support/helper/common'

When(/^I choose Upcoming Events from navigation bar$/) do
  on_page(HomePage).manage_upcoming
end

Then(/^I should be on the Upcoming Events Page$/) do
  on_page(ManagePage).check_upcoming_tab
end

When(/^I choose Archived Content from navigation bar$/) do
  on_page(HomePage).manage_archived
end

When(/^I click on permalink link on archived content view$/) do
  on_page(ArchivedContentPage).click_on_permalink_link
end

Then(/^I should be on the Archived Content Page$/) do
  on_page(ManagePage).check_archived_tab
end

Then(/^I see already processed webcast on archived content view$/) do
  processing_time = on_page(ArchivedContentPage).verify_embed_player_present_for_last_archived_event
  puts processing_time.to_s
end

When(/^I click on Download mp3 button if environment is not Production$/) do
  runtime_env_type = FigNewton.env_type
  if runtime_env_type != 'prod'
    on_page(ArchivedContentPage).download_archived_mp3
  end
end

Then(/^I am on Download mp3 page if environment is not Production$/) do
  runtime_env_type = FigNewton.env_type
  if runtime_env_type != 'prod'
    @browser.window(index: 1).wait_until_present(timeout = 30)
    on_page(ArchivedContentPage).attach_to_window(:url => "mp3")
    on_page(ArchivedContentPage).on_download_mp3_page
  end
end

When(/^I Choose Playlists from navigation bar$/) do
  on_page(HomePage).manage_playlist
end

Then(/^I should be on Playlist Page$/) do
  on_page(ManagePage).check_playlist_tab
end

Then(/^I go to home page$/) do
  on_page(StudioPage).go_home_page
end

Then(/^I go into the Studio$/) do
  event_title = $event_title
	on_page(HomePage).go_to_studio(event_title)
end

When(/^I go back to the Archived view from Permalink$/) do
  @browser.window(:index => 0).use
  on_page(HomePage).check_archived_view
end

Then(/^I go to edit my Upcoming Event$/) do
	on_page(HomePage).go_edit_upcoming_webcast
end

Then (/^I go to edit my Archived Event$/) do
	on_page(HomePage).go_edit_archived_webcast
end

Then(/^I get the reporting link$/) do
  event_title = $event_title
  $reportingURL = on_page(HomePage).get_reporting_link(event_title)
end

Then (/^I go to the reporting page$/) do
  @browser.execute_script("window.open('http://google.com')")
  Common.wait_for_new_window(@browser, 'Google', 30)
  on_page(ReportingPage).attach_to_window(:title => 'Google')
  @browser.goto($reportingURL)
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "reporting_title"), 30)
  on_page(ReportingPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "reporting_title"))
  on_page(ReportingPage).on_reporting_page
end

Then (/^I close the reporting page$/) do
  reportingURL = $reportingURL
  @browser.window(:url => "#{reportingURL}").use
  @browser.window(:url => "#{reportingURL}").close
 # @browser.execute_script("window.close")
end

Then(/^I get the permalink from home page$/) do
  $permalinkURL = on_page(HomePage).get_permalinkURL
end

Then (/^I go to the Permalink URL$/) do
  @browser.execute_script("window.open('http://google.com')")
  Common.wait_for_new_window(@browser, 'Google', 30)
  on_page(ReportingPage).attach_to_window(:title => 'Google')
  @browser.goto($permalinkURL)
end

Then (/^I see Account Info section with correct labels and phone numbers$/) do
  on_page(HomePage).check_account_info_section
end

Given(/^I click create on navigation bar$/) do
  on_page(HomePage).create_event('Create')
end