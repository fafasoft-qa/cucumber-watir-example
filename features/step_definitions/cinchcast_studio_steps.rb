require_relative '../support/helper/common'
require_relative '../support/helper/registration_api'

Then(/^I am in the studio$/) do
  on_page(StudioPage).in_studio
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "studio_title"), 60)
  on_page(StudioPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "studio_title"))
end

Then(/^I am in the studio access for presenters$/) do
  on_page(StudioPage).in_studio_access_for_presenters
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "studio_title"), 60)
  on_page(StudioPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "studio_title"))
end

Then(/^I see presenter in switchboard$/) do
  on_page(StudioPage).is_presenter_called_in
end

Then(/^I see host in switchboard$/) do
  on_page(StudioPage).is_host_called_in
end

Then(/^I see guest in switchboard$/) do
  on_page(StudioPage).is_guest_called_in
end

Then(/^I call in as host$/) do
  video = on_page(StudioPage).video_status_return
  on_page(StudioPage).wait_for_video(video)
  call_data = on_page(StudioPage).call_as_host
  puts call_data.to_s
end

Then(/^I upload PPT slides in studio$/) do
  on_page(StudioPage).studio_slide_upload("append", "ppt")
end

Then(/^I upload PPTX slides in studio$/) do
  on_page(StudioPage).studio_slide_upload("append", "pptx")
end

Then(/^I upload PDF slides in studio$/) do
  on_page(StudioPage).studio_slide_upload("append", "pdf")
end

Then (/^I verify slides in the timeline$/) do
  on_page(StudioPage).upload_verify
end

Then(/^I upload video in studio if video switch enabled$/) do
  if FigNewton.video_switch == "enabled"
    on_page(StudioPage).studio_video_upload
    on_page(StudioPage).video_status
  end
end

Then(/^I upload audio in studio$/) do
  on_page(StudioPage).upload_audio
end

Then(/^I delete audio clips in studio$/) do
  on_page(StudioPage).delete_audio_clips
end

Then(/^I call in as Presenter to added phone number for "([^"]*)"$/) do |country|
  event_title = $event_title
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if (runtime_env == 'platform.cinchcast.com') or (runtime_env == 'prod.cwebcast.com')
    country = 'QA (Fake Phone Numbers)'
  end
  phone_number = on_page(StudioPage).pick_presenter_phone_number(on_page(StudioPage).return_presenter_phone_number,country)
  conference_id = on_page(StudioPage).pick_presenter_popup_conf_id
  pin = on_page(RegistrationPage).get_presenter_pin("You have been made a Presenter for the event #{event_title}")
  puts "Presenter Call -  Phone Number\t\t=> #{phone_number.to_s}\n"
  puts "Presenter Call - Conference Id\t\t=> #{conference_id.to_s}\n"
  puts "Presenter Call -    PIN Number\t\t=> #{pin.to_s}\n"
  call_data = on_page(StudioPage).call_as_presenter(phone_number, pin, conference_id)
  puts call_data.to_s
  on_page(StudioPage).increase_caller_count
end

Then(/^I call in as Presenter to "([^"]*)" and "([^"]*)" phone number$/) do |toll_free, country|
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if (runtime_env == 'platform.cinchcast.com') or (runtime_env == 'prod.cwebcast.com')
    country = 'QA (Fake Phone Numbers)'
  end
  event_title = $event_title
  phone_number = on_page(StudioPage).pick_any_presenter_phone_number(toll_free,country)
  conference_id = on_page(StudioPage).pick_presenter_popup_conf_id
  pin = on_page(RegistrationPage).get_presenter_pin("You have been made a Presenter for the event #{event_title}")
  puts "Presenter Call -  Phone Number\t\t=> #{phone_number.to_s}\n"
  puts "Presenter Call - Conference Id\t\t=> #{conference_id.to_s}\n"
  puts "Presenter Call -    PIN Number\t\t=> #{pin.to_s}\n"
  call_data = on_page(StudioPage).call_as_presenter(phone_number, pin, conference_id)
  puts call_data.to_s
  on_page(StudioPage).increase_caller_count
end

Then(/^I call in as Guest to "([^"]*)" and "([^"]*)" phone number$/) do |toll_free, country|
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if (runtime_env == 'platform.cinchcast.com') or (runtime_env == 'prod.cwebcast.com')
    country = 'QA (Fake Phone Numbers)'
  end
  call_data = on_page(StudioPage).call_as_guest_no_pin_to_any_number(toll_free,country)
  puts call_data.to_s
  on_page(StudioPage).increase_caller_count
end

Then(/^I call in as Guest to added phone number for "([^"]*)"$/) do |country|
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if (runtime_env == 'platform.cinchcast.com') or (runtime_env == 'prod.cwebcast.com')
    country = 'QA (Fake Phone Numbers)'
  end
  call_data = on_page(StudioPage).call_as_guest_no_pin_to_specific_number(on_page(StudioPage).return_guest_phone_number,country)
  puts call_data.to_s
  on_page(StudioPage).increase_caller_count
end

Then (/^I call in as Registered Guest to added phone number for "([^"]*)"$/) do |country|
  event_title = $event_title
  phone_number = on_page(StudioPage).pick_guest_phone_number(on_page(StudioPage).return_guest_phone_number, country)
  conference_id = on_page(StudioPage).pick_guest_popup_conf_id
  pin = on_page(RegistrationPage).get_guest_pin("You have successfully registered for #{event_title}")
  puts "Reg Guest Call -  Phone Number\t\t=> #{phone_number.to_s}\n"
  puts "Reg Guest Call - Conference Id\t\t=> #{conference_id.to_s}\n"
  puts "Reg Guest Call -    PIN Number\t\t=> #{pin.to_s}\n"
  call_data = on_page(StudioPage).call_as_guest_with_pin(phone_number, pin, conference_id)
  puts call_data.to_s
  on_page(StudioPage).increase_caller_count
end

Then (/^I call in as Registered Guest to "([^"]*)" and "([^"]*)" phone number$/) do |toll_free, country|
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if (runtime_env == 'platform.cinchcast.com') or (runtime_env == 'prod.cwebcast.com')
    country = 'QA (Fake Phone Numbers)'
  end
  event_title = $event_title
  phone_number = on_page(StudioPage).pick_any_guest_phone_number(toll_free,country)
  conference_id = on_page(StudioPage).pick_guest_popup_conf_id
  pin = on_page(RegistrationPage).get_guest_pin("You have successfully registered for #{event_title}")
  puts "Reg Guest Call -  Phone Number\t\t=> #{phone_number.to_s}\n"
  puts "Reg Guest Call - Conference Id\t\t=> #{conference_id.to_s}\n"
  puts "Reg Guest Call -    PIN Number\t\t=> #{pin.to_s}\n"
  call_data = on_page(StudioPage).call_as_guest_with_pin(phone_number, pin, conference_id)
  puts call_data.to_s
  on_page(StudioPage).increase_caller_count
end

Then (/^I verify caller count in studio$/) do
  count1 = on_page(StudioPage).get_caller_count
  count2 = on_page(StudioPage).call_count
  puts "Callers Count - Current Value shown in Studio\t\t=> #{count1}\n"
  puts "Callers Count - Expected Value\t\t=> #{count2}\n"
  on_page(StudioPage).compare_count(count1, count2)
end

Then (/^I verify listener count in studio$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "studio_title"), 30)
  on_page(StudioPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "studio_title"))
  sleep 30
  count1 = on_page(StudioPage).get_listener_count
  puts "Studio Listeners Count\t\t=> #{count1.to_s}\n"
  count2 = on_page(StudioPage).listen_count
  puts "Actual Calculated Listeners Count\t\t=> #{count2.to_s}\n"
  on_page(StudioPage).compare_count(count1, count2)
end

Then(/^I uncheck the raise hand filter$/) do
  on_page(StudioPage).uncheck_raised_hands_filter
end

Then(/^I go Live$/) do
  video = on_page(StudioPage).video_status_return
  on_page(StudioPage).wait_for_video(video)
  on_page(StudioPage).go_live
end

When(/^I go to Event Info tab$/) do
  on_page(StudioPage).studio_event_tab
end

When(/^I go to Slide tab$/) do
  on_page(StudioPage).studio_slide_tab
end

Then(/^I end the event$/) do
  on_page(StudioPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "studio_title"))
  on_page(StudioPage).end_the_event
end

Then(/^I delete the event$/) do
  on_page(StudioPage).studio_event_tab
  on_page(StudioPage).studio_delete_event
end

When(/^I click the permalink$/) do
  on_page(StudioPage).studio_go_to_permalink
  on_page(RegistrationPage).increase_page_view
  sleep 10
end

Then(/^I click on next slide$/) do
  on_page(StudioPage).next_slide
end

Then(/^I click on previous slide$/) do
  on_page(StudioPage).previous_slide
end

Then(/^I click on confirm to end the event$/) do
  on_page(StudioPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "studio_title"))
  on_page(StudioPage).confirm_end_event
  on_page(StudioPage).reset_count
end

Then(/^I wait '(\d+)' seconds$/) do |time|
  on_page(StudioPage).wait time.to_i
end

Given(/^I go to Chat tab$/) do
  on_page(StudioPage).studio_chat_tab
end

Given(/^I go to Polls tab$/) do
  on_page(StudioPage).studio_polls_tab
end

When(/^I check the percentage of poll option voted$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "studio_title"), 30)
  on_page(StudioPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "studio_title"))
  on_page(StudioPage).check_poll_option_percentage
end

When(/^I select and start a pre-existent Poll from Studio$/) do
  on_page(StudioPage).select_and_start_poll
end

Then(/^I go to Home page$/) do
  on_page(StudioPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "studio_title"))
  on_page(StudioPage).go_home_page
end

When(/^I send a valid registration from the registration api$/) do
  encrypted_id = on_page(StudioPage).return_permalink_encrypted_id
  puts Registration_API.registration(encrypted_id)
end

When(/^I send (\d+) valid registration from the registration api$/) do |arg|
  encrypted_id = on_page(StudioPage).return_permalink_encrypted_id
  puts Registration_API.registration_load_test(encrypted_id,arg)
end

When(/^I enter host nickname and "([^"]*)" chat message for "([^"]*)"$/) do |is_public, host|
  nickname = nil
  message = nil
  if host == 'host1'
    nickname = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host1_nickname")
    message = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host1_message")
  else
    nickname = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host2_nickname")
    message = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host2_message")
  end

  on_page(StudioPage).enter_host_name_for_chat(nickname)
  if (is_public == 'public')
    on_page(StudioPage).enter_host_message_for_public_chat(message)
  else
    on_page(StudioPage).enter_host_message_for_chat(message)
  end
end

When(/^I see host nickname and "([^"]*)" chat message for "([^"]*)"$/) do |is_public, who_is|
  nickname = nil
  message = nil
  case who_is
    when "host1"
      begin
        nickname = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host1_nickname")
        message = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host1_message")
      end
    when "host2"
      begin
        nickname = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host2_nickname")
        message = Common.get_test_data("chat_data.yml","hosts_studio_chat", "host2_message")
      end
    when "anonymous"
      begin
        nickname = 'Guest'
        message = Common.get_test_data("chat_data.yml","permalink_chat", "anonymous_message")
      end
    else
  end
  sleep 3
  if (is_public == 'public')
    on_page(StudioPage).verify_nickname_for_public_chat(nickname)
    on_page(StudioPage).verify_message_for_public_chat(message)
  else
    on_page(StudioPage).verify_host_nickname_for_chat(nickname)
    on_page(StudioPage).verify_host_message_for_chat(message)
  end
end

When(/^I open another Studio page for same event$/) do
  studioURL = @browser.url
  @browser.execute_script("window.open('http://google.com')")
  Common.wait_for_new_window(@browser, 'Google', 30)
  on_page(StudioPage).attach_to_window(:title => 'Google')
  sleep 2
  @browser.goto(studioURL)
  @browser.window(:index => 1).use
  on_page(StudioPage).in_studio
end

When(/^I go back to the first Studio page$/) do
  @browser.window(:index => 0).use
  on_page(StudioPage).in_studio
end

When(/^I set public chat on permalink page on$/) do
  on_page(StudioPage).chat_on_permalink_page_switch('on')
end