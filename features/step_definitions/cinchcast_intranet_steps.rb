require_relative '../support/helper/common'

When(/^I go to the intranet$/) do
  on_page(IntranetPage).go_to_intranet
end

When(/^I go to a specific clients settings$/) do
  runtime_env = FigNewton.env
  client_id = nil
  case runtime_env
    when 'platform.cinchcast.com','prod.cwebcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_prod")
    when 'qa-platform.cinchcast.com','qa.cwebcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_qa")
    when 'qa2-platform.cinchcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_qa")
    when 'qa3-platform.cinchcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_qa")
    when 'dev-platform.cinchcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_dev")
    when 'feature1-platform.cinchcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_dev")
    when 'feature2-platform.cinchcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_dev")
    when 'feature3-platform.cinchcast.com'
      client_id = Common.get_test_data("default.yml","intranet_viral_link_client", "clientid_for_dev")
    else
      fail 'environment variable did not match expected value'
  end
  on_page(IntranetPage).go_to_clients(client_id)
end

When(/^I go to email pin search page$/) do
  on_page(IntranetPage).go_to_email_pin_search
end

When(/^I enter viral link Text as "(.*?)" and viral link URL as "(.*?)"$/) do |text, link|
  @link_text = text
  @link_URL = link
  on_page(IntranetPage).set_viral(text ,link)
end

When(/^I am on email pin search page$/) do
  on_page(IntranetPage).check_email_pin_search_page
end

When(/^I search for an Email on Email Pin Search page$/) do
  on_page(IntranetPage).search_on_email_pin_search_page_by('email')
end

When(/^I search for a PIN on Email Pin Search page$/) do
  on_page(IntranetPage).search_on_email_pin_search_page_by('pin')
end

When(/^I search for junk data on Email Pin Search page$/) do
  on_page(IntranetPage).search_on_email_pin_search_page_by('junk')
end

Then(/^I get results from Email Pin Search$/) do
  on_page(IntranetPage).email_pin_search_check_results_list
end

Then(/^I get no results from Email Pin Search$/) do
  on_page(IntranetPage).email_pin_search_check_no_results_message
end

Then(/^the client is updated$/) do
  on_page(IntranetPage).client_updated
end

When(/^I verify that the viral link text is displayed correctly$/) do
  event_title = $event_title
  Common.wait_for_new_window(@browser, event_title, 30)
  on_page(StudioPage).attach_to_window(:title => "#{event_title}")
  actualText = @link_text
  on_page(PermalinkPage).check_viral_text(actualText)
end

When(/^I verify that the viral link URL is correct$/) do
  event_title = $event_title
  Common.wait_for_new_window(@browser, event_title, 30)
  on_page(StudioPage).attach_to_window(:title => "#{event_title}")
  actualURL = @link_URL
  on_page(PermalinkPage).check_viral_link(actualURL)
end
