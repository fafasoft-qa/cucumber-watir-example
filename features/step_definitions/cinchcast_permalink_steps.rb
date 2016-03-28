require_relative '../support/helper/common'

Then(/^I am on the permalink page$/) do
  on_page(StudioPage).increase_listener_count
  on_page(StudioPage).attach_to_window(:title => "#{$event_title}")
  on_page(PermalinkPage).on_permalink
end

Then(/^the webcast permalink being processed$/) do
  on_page(StudioPage).attach_to_window(:title => "#{$event_title}")
  on_page(PermalinkPage).check_processing
end

When(/^I go back to Archived Content view$/) do
  on_page(PermalinkPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "archived_title"))
end

Then(/^I see already processed webcast on permalink page$/) do
  on_page(StudioPage).attach_to_window(:title => "#{$event_title}")
  processing_time = on_page(PermalinkPage).verify_archived_content_player_for_ended_event
  puts processing_time.to_s
end

Then(/^I am in preshow on permalink$/) do
  on_page(StudioPage).attach_to_window(:title => "#{$event_title}")
  on_page(PermalinkPage).check_in_preshow
end

Then (/^I see the correct slide on Permalink$/) do
  on_page(StudioPage).attach_to_window(:title => "#{$event_title}")
  permalink_slide = on_page(PermalinkPage).active_slide
  on_page(StudioPage).attach_to_window(:title => 'Studio : Cinchcast Inc')
  studio_slide = on_page(StudioPage).current_slide
  on_page(PermalinkPage).compare_slides(studio_slide, permalink_slide)
end

When(/^I see nickname and chat message for "([^"]*)" on permalink chat$/) do |who_is|
  nickname = nil
  message = nil
  if who_is == 'host1'
    nickname = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host1_nickname")
    message = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host1_message")
  else
    nickname = 'Guest'
    message = Common.get_test_data("chat_data.yml","permalink_chat", "anonymous_message")
  end
  sleep 3
  on_page(PermalinkPage).verify_nickname_and_message_for_public_chat(nickname,message)
end

When(/^I enter a chat message for "([^"]*)" on permalink chat$/) do |who_is|
  message = nil
  if who_is == 'anonymous'
    message = Common.get_test_data("chat_data.yml","permalink_chat", "anonymous_message")
  else
  end
  on_page(PermalinkPage).enter_message_for_public_chat(message)
end

When(/^I vote for started poll$/) do
  on_page(PermalinkPage).vote_for_started_poll
end



