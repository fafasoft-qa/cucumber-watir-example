require_relative '../support/helper/common'

Given(/^I removed all upcoming shows$/) do
  on_page(HomePage).remove_upcoming
end

Given(/^I enter the event title$/) do
  on_page(NewCreateEditEvent).first_tab_event_details
  on_page(NewCreateEditEvent).add_title(Common.get_test_data("default.yml","event_form_data", "title"))
end

Given(/^I enter the event description$/) do
  on_page(NewCreateEditEvent).third_tab_page_design
  on_page(NewCreateEditEvent).add_description(Common.get_test_data("default.yml","event_form_data", "description"))
end

Given(/^I add a Presenter with Dial-In and Studio-Access$/) do
  email = Common.get_test_data("default.yml", "presenter_email", "email")
  on_page(NewCreateEditEvent).second_tab_presenters
  on_page(NewCreateEditEvent).presenter_registration(email,:firstname => "John" ,:lastname => "Smith",:phone => "134789999",:dial_in => true,:studio_access => true)
end

Given(/^I add a Presenter with Dial-In$/) do
  email = Common.get_test_data("default.yml", "presenter_email", "email")
  on_page(NewCreateEditEvent).second_tab_presenters
  on_page(NewCreateEditEvent).presenter_registration(email,:firstname => "John" ,:lastname => "Smith",:phone => "134789999",:dial_in => true)
end

Given(/^I turn on guest registration$/) do
  on_page(NewCreateEditEvent).first_tab_event_details
  on_page(NewCreateEditEvent).guest_registration('yes')
  sleep 5
end

Given(/^I turn off guest registration$/) do
  on_page(NewCreateEditEvent).first_tab_event_details
  on_page(NewCreateEditEvent).guest_registration('no')
  sleep 5
end

Given(/^I upload a powerpoint PPT on slide show tab$/) do
  on_page(NewCreateEditEvent).fourth_tab_materials
  on_page(NewCreateEditEvent).create_slide_upload("append", "ppt")
end

When(/^I click save$/) do
  on_page(NewCreateEditEvent).create_save
  puts "EVENT TITLE\t\t=> #{$event_title.to_s}\n"
end

Given(/^I edit the event title$/) do
  on_page(NewCreateEditEvent).first_tab_event_details
  on_page(NewCreateEditEvent).add_title(Common.get_test_data("default.yml","event_form_data", "edit_title"))
end

Given(/^I edit the event description$/) do
  on_page(NewCreateEditEvent).third_tab_page_design
  on_page(NewCreateEditEvent).add_description(Common.get_test_data("default.yml","event_form_data", "edit_description"))
end

Given(/^I upload startup audio$/) do
  on_page(NewCreateEditEvent).fifth_tab_advanced
  on_page(NewCreateEditEvent).upload_startup_audio
end

When(/^I enter Charge Back Codes$/) do
  on_page(NewCreateEditEvent).first_tab_event_details
  on_page(NewCreateEditEvent).add_chargebackcodes
end

When(/^I set up a basic event without registration required to go live now for "([^"]*)" and "([^"]*)" phone numbers$/) do |toll_free, country|
  on_page(HomePage).create_event('Create')
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if runtime_env == 'prod'
    country = 'QA (Fake Phone Numbers)'
  end
  on_page(NewCreateEditEvent).add_title(Common.get_test_data("default.yml","event_form_data", "title"))
  on_page(NewCreateEditEvent).guest_registration('no')
  on_page(NewCreateEditEvent).manage_phone_numbers('yes')
  on_page(NewCreateEditEvent).check_phone_number_toll_type_for_country(toll_free, country)
  on_page(NewCreateEditEvent).add_chargebackcodes
  on_page(NewCreateEditEvent).third_tab_page_design
  on_page(NewCreateEditEvent).add_description(Common.get_test_data("default.yml","event_form_data", "description"))
  sleep 5
end

When(/^I set up a basic event without registration required to go live now$/) do
  on_page(HomePage).create_event('Create')
  on_page(NewCreateEditEvent).add_title(Common.get_test_data("default.yml","event_form_data", "title"))
  on_page(NewCreateEditEvent).guest_registration('no')
  on_page(NewCreateEditEvent).add_chargebackcodes
  on_page(NewCreateEditEvent).third_tab_page_design
  on_page(NewCreateEditEvent).add_description(Common.get_test_data("default.yml","event_form_data", "description"))
  sleep 5
end

When(/^I open Create Event page to create a new event$/) do
  on_page(HomePage).create_event('Create')
end

When(/^I verify the selected Tab by default$/) do
  on_page(NewCreateEditEvent).verify_selected_tab_by_default
end

When(/^I verify Sunday is the first weekday on Calendar$/) do
  on_page(NewCreateEditEvent).verify_sunday_first_weekday
end

When(/^I verify Event Date option for start now or later is not present anymore$/) do
  on_page(NewCreateEditEvent).verify_go_live_now_or_later_option_not_present_anymore
end

When(/^I verify Presenter Studio Access has Start End Event option unchecked$/) do
  on_page(NewCreateEditEvent).second_tab_presenters
  on_page(NewCreateEditEvent).verify_presenter_studio_access_start_end_event_unchecked
end

When(/^I verify Thank You popup message shown after saving event$/) do
  on_page(NewCreateEditEvent).verify_thank_you_popup_message_after_saving
end

When(/^Go back to Home page to create an overlapping live event$/) do
  on_page(StudioPage).reset_count
  on_page(RegistrationPage).reset_count
  on_page(StudioPage).go_home_page
end

When(/^I set up a basic event with registration required to go live now for "([^"]*)" and "([^"]*)" phone numbers$/) do |toll_free, country|
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if runtime_env == 'prod'
    country = 'QA (Fake Phone Numbers)'
  end
  on_page(HomePage).create_event('Create')
  on_page(NewCreateEditEvent).add_title(Common.get_test_data("default.yml","event_form_data", "title"))
  on_page(NewCreateEditEvent).add_chargebackcodes
  on_page(NewCreateEditEvent).third_tab_page_design
  on_page(NewCreateEditEvent).add_description(Common.get_test_data("default.yml","event_form_data", "description"))
  sleep 5
end

When(/^I set up a basic event with registration required to go live now$/) do
  on_page(HomePage).create_event('Create')
  on_page(NewCreateEditEvent).add_title(Common.get_test_data("default.yml","event_form_data", "title"))
  on_page(NewCreateEditEvent).add_chargebackcodes
  on_page(NewCreateEditEvent).third_tab_page_design
  on_page(NewCreateEditEvent).add_description(Common.get_test_data("default.yml","event_form_data", "description"))
  sleep 5
end

When(/^I set a custom registration description$/) do
  on_page(NewCreateEditEvent).third_tab_page_design
  on_page(NewCreateEditEvent).registration_desc_tab_element.when_present.focus()
  on_page(NewCreateEditEvent).registration_desc_tab_element.when_present.fire_event('onClick')
  on_page(NewCreateEditEvent).add_custom_registration_description(Common.get_test_data("default.yml","event_form_data", "custom_registration_description"))
end

Given(/^I upload a powerpoint PPT$/) do
  on_page(NewCreateEditEvent).fourth_tab_materials
  on_page(NewCreateEditEvent).create_slide_upload("append", "ppt")
end

Given(/^I upload a powerpoint PPTX$/) do
  on_page(NewCreateEditEvent).fourth_tab_materials
  on_page(NewCreateEditEvent).create_slide_upload("append", "pptx")
end

Given(/^I upload a powerpoint PPTX with only one slide$/) do
  on_page(NewCreateEditEvent).fourth_tab_materials
  on_page(NewCreateEditEvent).create_slide_upload("append", "only_one_pptx")
end

Given(/^I upload a PDF$/) do
  on_page(NewCreateEditEvent).fourth_tab_materials
  on_page(NewCreateEditEvent).create_slide_upload("append", "pdf")
end

Given(/^I upload and append additional PPTX slides$/) do
  on_page(NewCreateEditEvent).fourth_tab_materials
  on_page(NewCreateEditEvent).create_slide_upload("append", "pptx")
end

Given(/^I upload and replace previous PPTX slides$/) do
  on_page(NewCreateEditEvent).fourth_tab_materials
  on_page(NewCreateEditEvent).create_slide_upload("replace", "pptx")
end

Given(/^I upload a video if video switch enabled$/) do
  if FigNewton.video_switch == "enabled"
    on_page(NewCreateEditEvent).fourth_tab_materials
    on_page(NewCreateEditEvent).create_video_upload
    on_page(StudioPage).video_status
    #Adding sleep because processing time
    sleep 60
  end
end

When(/^I set public chat on$/) do
  on_page(NewCreateEditEvent).fifth_tab_advanced
  on_page(NewCreateEditEvent).public_chat_switch('on')
  sleep 5
end

When(/^I set adjust pre event environment on '(\d+)' minutes$/) do |minutes|
  on_page(NewCreateEditEvent).fifth_tab_advanced
  on_page(NewCreateEditEvent).adjust_pre_event_env_switch('yes')
  on_page(NewCreateEditEvent).edit_preshow_env_minutes(minutes)
  sleep 5
end

Given(/^I upload a preview image$/) do
  on_page(NewCreateEditEvent).fifth_tab_advanced
  on_page(NewCreateEditEvent).preview_image_upload
  sleep 5
end

Then(/^I should be on createeventpage$/) do
  on_page(CreateEditEvent).check_eventpage
end

When(/^I set the duration time to (\d+):(\d+)$/) do |arg1,arg2|
  on_page(CreateEditEvent).enter_duration_time(arg1 , arg2)
end
