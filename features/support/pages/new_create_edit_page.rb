#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'
require 'net/http'
require 'uri'
require_relative '../helper/common'

class SaveEventCustomError < StandardError
end

class GoLiveNowIrLaterOptionCustomError < StandardError
end

class NewCreateEditEvent
  include PageObject
  include DataMagic

  #When defining all 3, make sure email goes first
  EMAIL = 0
  FIRST = 1
  LAST = 2

  #Tab Basic

  label(:manage_phone_numbers_yes, :css => "div[ng-model='model.showPhoneNumbers'] label[ng-click='toggle(!options.inverted)']")
  label(:manage_phone_numbers_no, :css => "div[ng-model='model.showPhoneNumbers'] label[ng-click='toggle(options.inverted)']")
  text_field(:title, :id => 'Container_Title')
  element(:long_description, :frame, :id =>'Container_LongDescription_ifr')
  text_field(:unload_description, :id => 'Container_LongDescription')
  text_field(:unload_custom_reg_description, :id => 'Container_RegistrationDescription')
  element(:edit_description, :body, :id => 'tinymce')
  div(:slider, :class => 'ng-pristine ng-valid ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all')
  label(:go_live, :css => "label[for='GoLiveNow_true']")
  label(:start_later, :css => "label[for='GoLiveNow_false']")
  #Start now Time
  #text_field(:duration_hours, :ng_model => 'hours')
  #text_field(:duration_minutes, :ng_model => 'minutes')
  text_field(:duration_hours, :class => 'bt-span1 bt-text-center ng-pristine ng-valid')
  text_field(:duration_minutes, :class => 'bt-span1 bt-text-center ng-pristine ng-valid')
  #Start later time and date
  button(:calendar_type, :class => 'bt-btn bt-btn-block')
  select_list(:timezone, :ng_model => 'eventInfo.TimeZoneId')
  table(:start_date_container, :ng_model  => 'startDateTime')
  table(:start_date_container, :ng_model  => 'endTime')
  button(:calendar_button, :class => 'calendar-btn')
  button(:calendar_now_button, :css => "button[ng-click='now()']")
  button(:calendar_right, :class => 'bt-btn bt-pull-right')
  button(:calendar_left, :class => 'bt-btn bt-pull-left')
  element(:calendar_first_weekday, :css => "table[ng-switch-when='day'] thead tr:nth-of-type(2) th:nth-of-type(2) small")
  div(:create_div, :id=>'div-create-edit')

  #Tab Settings

  label(:display_calling_number_true, :for => 'DisplayListenerCallinNumber')
  label(:display_calling_number_false, :for => 'DisplayListenerCallinNumber_false')
  link(:upload_image,:id => 'aFireImgUploader')
  file_field(:filefield, :name => 'file', :index => 1)
  file_field(:filefield_preview_image, :css => "form[name='advancedForm'] fieldset:nth-of-type(1) div#popup-upload-one input[type='file']")
  label(:adjust_pre_event_env_yes, :css => "div[ng-model='adjustPreEventTimeEnabled'] label[ng-click='toggle(!options.inverted)']")
  label(:adjust_pre_event_env_no, :css => "div[ng-model='adjustPreEventTimeEnabled'] label[ng-click='toggle(options.inverted)']")
  text_field(:preshow_env_minutes, :css => "div[ng-show='adjustPreEventTimeEnabled'] input")

  #Tab Presenters

  link(:add_presenter, :id => 'button-addguest')
  text_field(:guest_first_name, :id => 'guest-first-name')
  text_field(:guest_last_name, :id => 'guest-last-name')
  text_field(:guest_email, :id => 'guest-email')
  text_field(:guest_phone, :id => 'guest-phone')
  checkbox(:presenter_dial_in, :css => "input[name='dial-in']")
  checkbox(:presenter_studio_access, :css => "input[name='studio-access']")
  checkbox(:presenter_featured_speaker, :css => "input[name='featured-speaker']")
  checkbox(:presenter_switchboard, :css => "input[name='studio-access-switchboard']")
  checkbox(:presenter_slides, :css => "input[name='studio-access-slide']")
  checkbox(:presenter_info, :css => "input[name='studio-access-info']")
  checkbox(:presenter_qa, :css => "input[name='studio-access-qa']")
  checkbox(:presenter_polling, :css => "input[name='studio-access-polling']")
  checkbox(:presenter_audioclips, :css => "input[name='studio-access-audioclips']")
  checkbox(:presenter_start_end, :css => "input[name='studio-access-startendevent']")
  checkbox(:presenter_bio, :css => "textarea[name='biography']")
  file_field(:presenter_upload_picture, :css => "div[cc-tab='presenters'] input[name='file']")

  #Tab Registration
  label(:registration_yes, :css => "div[ng-model='eventInfo.Registration.IsEnabled'] label[ng-click='toggle(!options.inverted)']")
  label(:registration_no, :css => "div[ng-model='eventInfo.Registration.IsEnabled'] label[ng-click='toggle(options.inverted)']")
  label(:shut_off_reminder_emails_yes, :css =>  "div[ng-model='eventInfo.ShouldSendEventReminders'] label[ng-click='toggle(!options.inverted)']")
  label(:shut_off_reminder_emails_no, :css =>  "div[ng-model='eventInfo.ShouldSendEventReminders'] label[ng-click='toggle(options.inverted)']")
  #@browser.label(:for => /^(.*HasRegistration_false$)/).exists?

  #Tab Slideshow
  file_field(:filefield_video, :id => 'file_data')
  div(:upload_progress, :id => 'pptUploader-container')
  div(:video_upload_progress, :id => 'vidUploader-container')
  div(:video_uploader_new, :css=>'div.slide-uploader div[ng-show="model.videoUploaderModel.currentUpload && !model.videoUploaderModel.isUploadInProgress"]')
  file_field(:filefield_slideshow, :xpath => "//div[@cc-tab='slideshow']/div/fieldset/div/div/div/div/div/input[@type='file']")
  div(:upload_bar, :id => 'upload-progress')
  div(:processing_bar, :id => 'slide-processing')

  #Tab AudioClips

  #file_field(:filefield_audio, :name => 'file', :index => 1)
  file_field(:filefield_audio, :css => "form[name='advancedForm'] fieldset:nth-of-type(2) div[ng-show='showUploader'] input[type='file']")

  #Common
  button(:save, :id => 'aSaveRecording')

  #not in use
  div(:selectfile, :id => 'file-upload-button')
  a(:upload_audio, :title => 'Upload startup audio')
  a(:registration_desc_tab, :css => "li[cc-tabheader='registrationDescription'] a")
  a(:new_upload_audio, :css => "form[name='advancedForm'] a[title='upload']")
  li(:upload_success, :class => 'hide qq-upload-success')

  label(:chat_studio_only, :for => 'Webcast_ShowChat_false')
  label(:public_chat_on, :css => "div[ng-model='eventInfo.PublicChatEnabled'] label[ng-click='toggle(!options.inverted)']")
  label(:public_chat_off, :css => "div[ng-model='eventInfo.PublicChatEnabled'] label[ng-click='toggle(options.inverted)']")
  label(:chat_permalink, :for => 'Webcast_ShowChat_true')
  label(:append_slides, :css => 'label#slides-append-label')
  label(:replace_slides, :css => 'label#slides-replace-label')
  link(:import_library, :class => '')
  link(:save_library, :class => '')
  radio_button(:save_as_new, :class => '')
  radio_button(:overwrite_existing, :class => '')
  text_field(:name_new_library, :class => '')
  button(:save_overwrite_library, :class => '')
  select_list(:import_from_list, :class => '')
  label(:append_library, :class => '')
  label(:replace_library, :class => '')
  text_field(:internal_notes, :class => '')
  select_list(:registration_form, :class => '')
  select_list(:batch_list, :class => '')
  #radio_button(:display_number_on, :css => 'input[data-val = "true"]')
  label(:display_number_off, :for => '')
  label(:display_number_on, :for => '')
  label(:email_event_info, :class => '')
  label(:question_answer, :class => '')
  div(:saved_event_popup_message, css: "div#popup-saved-event div.popup-message.ng-scope")

  #New def's
  def enter_duration_time(hours, minutes)
    if((hours.to_i > 23) and (minutes.to_i>59))
      fail
      #  $stdout.print "Hours should be between 00 and 23 -hours=#{hours}. Minutes should be between 00 and 59 -minutes=#{minutes}"
    else
      self.duration_hours = hours
      self.duration_minutes = minutes
    end
  end

  #TABS NAVIGATION

  def first_tab_event_details
    @browser.elements(:css=>'ul.nav li.ng-isolate-scope a')[0].when_present(timeout = 30).fire_event("click")
    sleep 10
  end
  def second_tab_presenters
    @browser.elements(:css=>'ul.nav li.ng-isolate-scope a')[1].when_present(timeout = 30).fire_event("click")
    sleep 10
  end
  def third_tab_page_design
    @browser.elements(:css=>'ul.nav li.ng-isolate-scope a')[2].when_present(timeout = 30).fire_event("click")
    sleep 10
  end
  def fourth_tab_materials
    @browser.elements(:css=>'ul.nav li.ng-isolate-scope a')[3].when_present(timeout = 30).fire_event("click")
    sleep 10
  end
  def fifth_tab_advanced
    @browser.elements(:css=>'ul.nav li.ng-isolate-scope a')[4].when_present(timeout = 30).fire_event("click")
    sleep 10
  end

  #TAB BASIC METHODS

  def add_title(name)
    time = Time.new
    date_time = "#{time.month}/#{time.day}/#{time.year} #{time.hour}:#{time.min}:#{time.sec}"
    title_and_date = name+" "+date_time
    self.title_element.when_present(timeout = 30).send_keys(title_and_date)
    $event_title = title_and_date.to_s
  end

  def verify_selected_tab_by_default
    self.title_element.wait_until_present(timeout = 30)
  end

  def verify_presenter_studio_access_start_end_event_unchecked
    add_presenter_element.when_present(timeout = 30).focus()
    add_presenter_element.when_present(timeout = 30).fire_event('onClick')
    presenter_studio_access_element.set(true)
    presenter_start_end_element.wait_until_present(timeout=5)
    fail unless !presenter_start_end_checked?
  end

  def verify_sunday_first_weekday
    self.calendar_button_element.when_present(timeout = 15).click
    fail unless @browser.element(:css => "table[ng-switch-when='day'] thead tr:nth-of-type(2) th:nth-of-type(2) small").when_present.text.include?("Sun")
  end

  def verify_go_live_now_or_later_option_not_present_anymore
    go_live_now_or_later_option_present =  go_live_element.wait_until_present(timeout = 15) rescue false
    raise GoLiveNowIrLaterOptionCustomError, 'Go live now or Start later option should not exist anymore on create event page' if go_live_now_or_later_option_present
  end

  def verify_thank_you_popup_message_after_saving
    fail unless self.saved_event_popup_message_element.when_present(timeout = 30).text.include?("Your event has been saved.")
  end

  def edit_title(edit_title)
    time = Time.new
    date_time_edit = "#{time.month}/#{time.day}/#{time.year} #{time.hour}:#{time.min}:#{time.sec}"
    title_and_date_edit = edit_title+" "+date_time_edit
    self.title = title_and_date_edit
    $event_title = title_and_date.to_s
  end

  def add_description(description)
    if @browser.element( :id =>'Container_LongDescription_ifr').when_present(timeout=60).exist?
      script = "tinymce.get('Container_LongDescription').execCommand('mceSetContent',false,'"+description+"');"
      @browser.execute_script(script)
    else
      self.unload_description_element.when_present(timeout = 30).send_keys(description)
    end
  end

  def edit_preshow_env_minutes(minutes)
    self.preshow_env_minutes_element.when_present(timeout = 10).clear
    self.preshow_env_minutes_element.when_present.send_keys(minutes)
  end

  def add_chargebackcodes
    #cbcs = @browser.elements(:css => 'fieldset#basics-tab.tabcontent fieldset input[id^="ChargeBackCodeFields"][type=text]')
    cbcs = Array.new
    timeout = 60
    counter  = 0
    while( (@browser.ready_state != "complete") and (counter < timeout) )
      sleep(1)
      ++counter
    end
    cbcs = @browser.elements(:css => 'div.chargebackcodes fieldset.ng-pristine input.ng-scope')
    cbcs.each do |e|
      e.to_subtype.send_keys('123')
    end
  end

  #TAB PRESENTERS METHODS

  def presenter_registration(email, options = {})
    # Default options setting and merging with sent parameters
    options = {firstname: nil, lastname: nil, phone: nil,dial_in: nil, studio_access: nil, featured_speaker: nil,
    switchboard: nil, slides: nil, info: nil, q_and_a: nil, polling: nil, audio_clips: nil, start_end: nil, bio: nil, picture: nil}.merge(options)
    # Adding email (only required field)
    add_presenter_element.when_present(timeout = 30).focus()
    add_presenter_element.when_present(timeout = 30).fire_event('onClick')
    guest_email_element.when_present(timeout = 30).send_keys(email)

    if options[:firstname] != nil
      guest_first_name_element.when_present(timeout = 30).send_keys(options[:firstname])
    end
    if options[:lastname] != nil
      guest_last_name_element.when_present(timeout = 30).send_keys(options[:lastname])
    end
    if options[:phone] != nil
      guest_phone_element.when_present(timeout = 30).send_keys(options[:phone])
    end

    fail unless @browser.checkbox(:css => "input[name='dial-in']").when_present(timeout=30).set?

    if options[:dial_in] != nil
      case options[:dial_in]
        when true
          presenter_dial_in_element.set(true)
        when false
          presenter_dial_in_element.clear
        else
      end
    end

    if options[:studio_access] != nil
      case options[:studio_access]
        when true
          presenter_studio_access_element.set(true)

          if options[:switchboard] != nil
            case options[:switchboard]
              when true
                presenter_switchboard_element.set(true)
              when false
                presenter_switchboard_element.clear
              else
            end
          end

          if options[:slides] != nil
            case options[:slides]
              when true
                presenter_slides_element.set(true)
              when false
                presenter_slides_element.clear
              else
            end
          end

          if options[:info] != nil
            case options[:info]
              when true
                presenter_info_element.set(true)
              when false
                presenter_info_element.clear
              else
            end
          end

          if options[:q_and_a] != nil
            case options[:q_and_a]
              when true
                presenter_qa_element.set(true)
              when false
                presenter_qa_element.clear
              else
            end
          end

          if options[:polling] != nil
            case options[:polling]
              when true
                presenter_polling_element.set(true)
              when false
                presenter_polling_element.clear
              else
            end
          end

          if options[:audio_clips] != nil
            case options[:audio_clips]
              when true
                presenter_audioclips_element.set(true)
              when false
                presenter_audioclips_element.clear
              else
            end
          end

          if options[:start_end] != nil
            case options[:start_end]
              when true
                presenter_start_end_element.set(true)
              when false
                presenter_start_end_element.clear
              else
            end
          end

        when false
          presenter_studio_access_element.clear
        else
      end
    end

    if options[:featured_speaker] != nil
      case options[:featured_speaker]
        when true
          presenter_featured_speaker_element.set(true)

          if options[:bio] != nil
            case options[:bio]
              when true
                presenter_bio_element.when_present(timeout=30).set(true)
              when false
                presenter_bio_element.when_present(timeout=30).clear
              else
            end
          end

          if options[:picture] != nil
            case options[:picture]
              when true
                #upload image
                  DataMagic.load('default.yml')
                  files_path = DataMagic.yml["path_to_test_files"]
                  self.upload_image_element.when_present.click
                  sleep 2
                  #removes style attribute from the uploader
                  @browser.execute_script("document.getElementsByName('file')[0].removeAttribute('style')")
                  sleep 3
                  #sets filefield to filepath for uploading
                  filefield_element.value = Dir.pwd + files_path["preview_image1"]
                  sleep 8
              else
            end
          end
        when false
          presenter_featured_speaker_element.clear
        else
      end
    end
    @browser.link(:css => '#form-addguest.box .fp-picture-buttons a.btn.cta.ng-binding').fire_event('onClick')
    $total_reg = $total_reg + 1
    sleep 5
  end

  #TAB SETTINGS METHODS

  def preview_image_upload
    DataMagic.load('default.yml')
    files_path = DataMagic.yml["path_to_test_files"]
    #self.upload_image_element.when_present.click
    @browser.link(:id => 'aFireImgUploader').fire_event('onClick')
    sleep 2
    #removes style attribute from the uploader
    @browser.execute_script("document.getElementsByClassName('btn huge qq-upload-button-selector qq-upload-button')[0].removeAttribute('style')")
    sleep 2
    @browser.execute_script("document.getElementsByName('qqfile')[0].removeAttribute('style')")
    sleep 3
    #sets filefield to filepath for uploading
    filefield_preview_image_element.value = Dir.pwd + files_path["preview_image1"]
    sleep 5
  end

  #turn on/off manage phone numbers
  def manage_phone_numbers(value)
    if value == 'yes'
      manage_phone_numbers_yes_element.when_present(timeout = 30).fire_event('onClick')
    elsif value == 'no'
      manage_phone_numbers_no_element.when_present(timeout = 30).fire_event('onClick')
    end
    sleep 3
  end

  #turn on/off send event reminders
  def shut_off_reminder_emails(value)
    if value == 'yes'
      shut_off_reminder_emails_yes_element.when_present(timeout = 30).fire_event('onClick')
    elsif value == 'no'
      shut_off_reminder_emails_no_element.when_present(timeout = 30).fire_event('onClick')
    end
  end

  #turn on/off public chat for the event
  def public_chat_switch(value)
    if value == 'on'
      public_chat_on_element.when_present.fire_event('onClick')
    elsif value == 'off'
      public_chat_off_element.when_present.fire_event('onClick')
    end
  end

  #turn yes/no adjust pre-event environment enabled for the event
  def adjust_pre_event_env_switch(value)
    if value == 'yes'
      adjust_pre_event_env_yes_element.when_present(timeout = 15).fire_event('onClick')
    elsif value == 'no'
      adjust_pre_event_env_no_element.when_present(timeout = 15).fire_event('onClick')
    end
  end

  #TAB REGISTRATION METHODS

  #turn on/off guest registration
  def guest_registration(registration)
    if registration == 'yes'
      registration_yes_element.when_present(timeout = 30).fire_event('onClick')
    elsif registration == 'no'
      registration_no_element.when_present(timeout = 30).fire_event('onClick')
    end
    sleep 5
  end

  def add_custom_registration_description(custom_reg_desc)
    if @browser.element( :id =>'Container_RegistrationDescription_ifr').when_present(timeout=60).exist?
      script = "tinymce.get('Container_RegistrationDescription').execCommand('mceSetContent',false,'"+custom_reg_desc+"');"
      @browser.execute_script(script)
    else
      self.unload_custom_reg_description_element.when_present(timeout = 30).send_keys(custom_reg_desc)
    end
  end

  #SLIDES

  #upload slides
  def create_slide_upload(action, type)
    DataMagic.load('default.yml')
    files_path = DataMagic.yml["path_to_test_files"]
    #@browser.link(:id => 'aAddSlide').fire_event('onClick')
    sleep 20
    @browser.link(:id => 'aAddSlide').when_present(timeout = 30).fire_event('onClick')
    sleep 10
    #append or replace
    if action == 'append'
      @browser.label(:for => 'slidesAppend').when_present(timeout = 30).fire_event('onClick')
    end
    if action == 'replace'
      @browser.label(:for => 'slidesReplace').when_present(timeout = 30).fire_event('onClick')
    end

    #removes style attribute from the uploader
    @browser.execute_script("document.getElementsByClassName('qq-upload-button-selector qq-upload-button btn')[0].removeAttribute('style')")
    sleep 2
    @browser.execute_script("document.getElementsByName('qqfile')[1].removeAttribute('style')")
    sleep 2

    uploader = filefield_slideshow_element

    sleep 2
    #sets filefield to filepath for uploading
    if type == "ppt"
      uploader.value = Dir.pwd + files_path["ppt_file1"]
      sleep 3
    elsif type == "pptx"
      uploader.value = Dir.pwd + files_path["pptx_file1"]
      sleep 3
    elsif type == "pdf"
      uploader.value = Dir.pwd + files_path["pdf_file1"]
      sleep 3
    elsif type == "only_one_pptx"
      uploader.value = Dir.pwd + files_path["only_one_pptx"]
      sleep 3
    end
    #New Validation
    upload_time_counter = 0
    begin
      if upload_bar_element.exists? #old create edit
      else #new create edit
        while processing_bar_element.visible?
          sleep 1
          $stdout.print "Slides are currently Uploading\n"
          upload_time_counter = upload_time_counter +1
          if upload_time_counter > 120
            $stdout.print "Slide upload has timed out after 120 seconds"
            upload_time_counter = 0
            fail
          end
        end
      end

      sleep 5

    rescue Timeout::Error
      puts("Caught a TIMEOUT ERROR! - Slides are currently Uploading\n ")
      sleep(1)
      # Retry the code that generates the esception.
      upload_time_counter = upload_time_counter +1
      retry if upload_time_counter < 10
      raise
    end
  end

  #upload videos
  def create_video_upload
    DataMagic.load('default.yml')
    files_path = DataMagic.yml["path_to_test_files"]
    @browser.link(:id => 'aAddVideo').fire_event('onClick')
    sleep 2
    #sets filefield to filepath for uploading
    filefield_video_element.value = Dir.pwd + files_path["video_mp4_file"]
    sleep 3
    #checks if video is uploading/processing
    if video_upload_progress?
      while video_upload_progress.include? 'uploaded and is now processing'
        $stdout.print "Video is currently uploaded and is now processing....\n"
        sleep 3
      end
    end
    if video_uploader_new?
      while video_uploader_new.include? 'uploaded and is now processing'
        $stdout.print "Video is currently uploaded and is now processing....\n"
        sleep 3
      end
    end
  end

  ############# AUDIOCLIPS TAB ###############

  #To upload startup audio from the create page
  def upload_startup_audio
    DataMagic.load('default.yml')
    files_path = DataMagic.yml["path_to_test_files"]
    new_upload_audio_element.when_present(timeout = 30).fire_event('onClick')
    sleep 2
    #removes style attribute from the uploader
    @browser.execute_script("document.getElementsByClassName('qq-upload-button-selector qq-upload-button btn')[0].removeAttribute('style')")
    sleep 2
    @browser.execute_script("document.getElementsByName('qqfile')[1].removeAttribute('style')")
    sleep 2
    #sets filefield to filepath for uploading
    filefield_audio_element.value = Dir.pwd + files_path["audio_file1"]
    sleep 30
  end

  ############# SLIDES TAB ###############

  def import_from_library(filename, option)
    import_library_element.fire_event('onClick')
    #set filename value to be selected in the list
    self.import_from_list = filename
    #choose append or replace
    if option == "append"
      append_library_element.click
    elsif option == "replace"
      replace_library_element.click
    end
  end

  def save_to_library(option, filename, overwrite_filename)
    save_library_element.fire_event('onClick')
    #save as new or overwrite
    if option == "new"
      check_save_as_new
    elsif option == "overwrite"
      check_overwrite_existing
      self.import_from_list = overwrite_filename
    end
    #write filename
    self.name_new_library = filename
    save_overwrite_library
  end

  ############# PHONE NUMBERS TAB ###############

  #turn on/off display callin number
  def display_callin_number(display)
    if display == 'off'
      #@browser.label(:for => 'DisplayListenerCallinNumber_false').fire_event('onClick')
      self.display_calling_number_false.fire_event('onClick')
    elsif display == 'on'
      #@browser.label(:for => 'DisplayListenerCallinNumber').fire_event('onClick')
      self.display_calling_number_true.fire_event('onClick')
    end
  end

  def check_toll_checkbox(country_code)
    if @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s).exists?
      if @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s).set?
        @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s).clear
      else
        @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s).set(true)
      end
    end
  end

  def check_toll_free_checkbox(country_code)
    if @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s + '_showtollfree').exists?
      if @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s + '_showtollfree').set?
        @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s + '_showtollfree').clear
      else
        @browser.checkbox(:id => 'selectedCountries_' + country_code.to_s + '_showtollfree').set(true)
      end
    end
  end

  def check_phone_number_toll_type_for_country(desired_toll_free, desired_country)
    countries = @browser.elements(:xpath => "//tr[@ng-repeat='phoneOption in eventInfo.PhonesDisplayOptions']/td/span[@class='ng-binding']")
    countries.each_with_index do |country,index|
      # Uncheck selected values by default
      toll = @browser.checkbox(:xpath =>"//tr[@ng-repeat='phoneOption in eventInfo.PhonesDisplayOptions']/td/input[@ng-show='phoneOption.IsTollNumberAvailable']", :index => index)
      toll_free = @browser.checkbox(:xpath =>"//tr[@ng-repeat='phoneOption in eventInfo.PhonesDisplayOptions']/td/input[@ng-show='phoneOption.IsTollFreeNumberAvailable']", :index => index)
      if country.text.include? 'US'
        if toll.exists? and toll.visible?
          if toll.set?
            toll.clear
          else
            toll.set(true)
          end
        end
        if toll_free.exists? and toll_free.visible?
          if toll_free.set?
            toll_free.clear
          else
            toll_free.set(true)
          end
        end
      end
      # Check required values
      if country.text.include? desired_country.to_s
        if (desired_toll_free.to_s == 'Toll Free')
          if toll.exists? and toll.visible?
            if toll.set?
              toll.clear
            else
              toll.set(true)
            end
          end
        else
          if toll_free.exists? and toll_free.visible?
            if toll_free.set?
              toll_free.clear
            else
              toll_free.set(true)
            end
          end
        end
        break
      end
    end
  end

  ############# PAGE METHODS ###############
  def create_save
    #@browser.button(:css => "div.grid.container.ng-scope:nth-of-type(2) input#aSaveRecording").fire_event('onClick')
    @browser.button(:css => "div.grid.container.ng-scope:nth-of-type(2) input#aSaveRecording").when_present(timeout = 30).click
    #If Resend Presenters Email popup is present click on Yes
    resend_presenters_email = @browser.element(:css=>"#btn-resend-presenter-emails-yes").when_present(timeout = 15).click rescue false
    #Server side Error handling
    error_present =  @browser.element(:xpath=>"//div[@class='alert fail']").wait_until_present(timeout = 30) rescue false
    raise SaveEventCustomError, 'Error saving Event' if error_present
  end

  #check to make sure on home page
  def check_eventpage
    unless create_div_element.when_present(timeout = 30).visible?
      fail
    end
  end
end
