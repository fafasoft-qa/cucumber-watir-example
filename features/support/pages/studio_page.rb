#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'
require 'watir-scroll'
require_relative '../helper/common'
require_relative '../helper/summon_api'
require_relative '../helper/summon_api_admin_location'
require_relative '../helper/summon_api_admin_access_line_pool'

class StudioPage

  #Using libraries
  include PageObject
  include PhoneUtils
  include DataMagic

  #Web-elements found in page
  div(:studio_page, :id => 'panel')
  li(:host_caller, :class => 'ng-scope host caller')
  li(:presenter_caller, :class => 'ng-scope  presenter caller')
  li(:guest_caller, :class => 'ng-scope  caller')
  checkbox(:raise_hand_filter, :id => 'chk-callers-question')
  link(:go_live_button, :id => 'go-live')
  link(:end_event, :id => 'btn-end-show')
  link(:waiting, :id => 'btn cta active waiting')
  link(:end_event_confirm, :id => 'btn-end-confirm')
  div(:studio_page, :id => 'studio-controller')
  a(:upload_slide, :class => 'btn icon-upload right')
  file_field(:filefield, :name => 'qqfile', :index => 0)
  file_field(:filefield_audio, :name => 'qqfile', :index => 1)
  link(:slide_tab, :css => "li[cc-tabheader='slides'] a")
  link(:event_info_tab, :css => "li[cc-tabheader='info'] a")
  link(:chat_tab, :css => "li[cc-tabheader='chat'] a")
  link(:qa_tab, :css => "li[cc-tabheader='questionsAndAnswers'] a")
  link(:polls_tab, :css => "li[cc-tabheader='polls'] a")

  div(:slide_timeline, :class => 'slide-timeline')
  element(:permalink, :a, :css => 'div#episode-info dl dd a')
  dd(:conference_pin, :id => 'conferencePin')
  dd(:host_number, :id => 'hostNumber')
  dd(:host_pin, :id => 'hostPin')
  a(:next_slide, :class => 'view-next')
  a(:previous_slide, :class => 'view-prev')
  div(:current_slide, :class =>'slide-viewer')
  img(:slide, :class => 'view-image')
  span(:listeners, :id => 'listener-count')
  dd(:callers, :id => 'caller-count')
  a(:home, :href => '/')
  div(:video_processing, :css => 'a.slide.ng-scope.video div.transcoding.ng-hide')
  div(:onair, :id => 'onair')
  div(:waiting_live, :id => 'timer')
  div(:upload_progress, :id => 'upload-progress')
  file_field(:filefield_video, :id => 'file_data')
  div(:video_upload_progress, :id => 'video-uploader')
  div(:popup, :id => 'popup-disconnected')
  a(:close_popup, :class => 'close')

  element(:chat_host_nickname_textbox, :css => 'div#tab-4 input[ng-model="model.presenterName"]')
  element(:quest_answ_host_nickname_textbox, :css => 'div#tab-5 input[ng-model="model.presenterName"]')
  element(:chat_host_message_textbox, :css => 'div#tab-4 input[ng-model="model.privateChatEntry"]')
  element(:quest_answ_message_textbox, :css => 'div#tab-5 input[ng-model="model.privateChatEntry"]')

  label(:chat_on_permalink_page_on, :css =>'div#div-public-chat-container div label:nth-of-type(1)')
  label(:chat_on_permalink_page_off, :css =>'div#div-public-chat-container div label:nth-of-type(2)')

  div(:popup, :class => 'popup-block')
  link(:close_popup, :link => 'End the Event')
  a(:upload_audio, :id => 'button-audio-upload')
  a(:audio_save, :id => 'button-upload')
  li(:audio_clips, :class => 'audioclip')
  a(:delete_audio, :title => 'delete audio clip')
  a(:guest_callin_button, :id => 'btn-show-guest-numbers')
  a(:presenter_callin_button, :id => 'btn-show-presenter-numbers')
  li(:guest_numbers, :css => '#popup-guestnumbers ul li')
  li(:presenter_numbers, :css => '#popup-presenternumbers ul li')
  li(:new_guest_numbers, :css => 'div[name="popup-guestnumbers"] ul li')
  li(:new_presenter_numbers, :css => 'div[name="popup-presenternumbers"] ul li')
  a(:guest_popup_close_button, :css =>'#popup-guestnumbers a.close')
  a(:presenter_popup_close_button, :css =>'#popup-presenternumbers a.close')
  a(:new_guest_popup_close_button, :css =>'div[name="popup-guestnumbers"] a.close')
  a(:new_presenter_popup_close_button, :css =>'div[name="popup-presenternumbers"] a.close')
  a(:new_poll_from_template_button, :css =>'a[ng-click="addPollFromTemplates()"]')
  select_list(:poll_manager_select, :css => "div.pollForm select")
  a(:polls_select_and_edit_button, :css =>'div.pollForm input.right')
  a(:polls_manager_save_button, :css =>'div.pollForm a.btn.cta.right')
  a(:polls_start_button, :css =>'div.polls-current a.btn.cta.right')
  span(:polls_second_percentage, :css =>'div.ng-scope:nth-of-type(4) span.poll-option-text:nth-of-type(2)')
  span(:polls_fourth_percentage, :css =>'div.ng-scope:nth-of-type(6) span.poll-option-text:nth-of-type(2)')
  span(:polls_fifth_percentage, :css =>'div.ng-scope:nth-of-type(7) span.poll-option-text:nth-of-type(2)')
  span(:polls_second_poll_answers_count, :css =>'div.ng-scope:nth-of-type(4) span.poll-option-text:nth-of-type(3)')
  span(:polls_fourth_poll_answers_count, :css =>'div.ng-scope:nth-of-type(6) span.poll-option-text:nth-of-type(3)')
  span(:polls_fifth_poll_answers_count, :css =>'div.ng-scope:nth-of-type(7) span.poll-option-text:nth-of-type(3)')
  #input(:qa_on, :value => 'enabled')
  #input(:qa_off, :value => 'disabled')
  #text_field(:qa_display, :ng-model => "presenterName")

  #Local constants
  TIMEOUT = 120

  #global variables
  $caller_count = 0
  $listener_count = 0
  $video = "No"
  $presenter_phone_number = ''
  $guest_phone_number = ''

  #Navigate to Event Info tab
  def studio_event_tab
    @browser.scroll.to :top
    sleep 1
    event_info_tab_element.when_present(timeout = 15).click
    sleep 2
  end

  def return_presenter_phone_number
    return $presenter_phone_number.to_s
  end

  def return_guest_phone_number
    return $guest_phone_number.to_s
  end

  def set_presenter_phone_number(number)
    return $presenter_phone_number = number.to_s
  end

  def set_guest_phone_number(number)
    return $guest_phone_number = number.to_s
  end

  #Navigate to Slide tab
  def studio_slide_tab
    sleep 2
    slide_tab_element.when_present(timeout = 30).fire_event('onClick')
    sleep 20
  end

  #Navigate to Chat tab
  def studio_chat_tab
    sleep 2
    chat_tab_element.when_present(timeout = 15).click
    sleep 2
  end

  #Navigate to Polls tab
  def studio_polls_tab
    sleep 2
    polls_tab_element.when_present(timeout = 15).click
    sleep 2
  end

  #Navigate to Q&A tab
  def studio_qa_tab
    sleep 2
    qa_tab_element.when_present(timeout = 15).click
    sleep 2
  end

  def qa_status(option)
    if option == "On"
      qa_on_element.set
    else
      qa_off_element.set
    end
  end

  def qa_username(username)
    self.qa_display = username
  end

  #Click on the delete link in Event Info tab
  def studio_delete_event
    @browser.link(:id => 'btn-delete-show').click
    @browser.link(:id => 'btn-delete-confirm').click
  end

  #Upload Slides where action can be append or replace
  def studio_slide_upload(action, type)
    DataMagic.load('default.yml')
    files_path = DataMagic.yml["path_to_test_files"]
    upload_slide_element.fire_event('onClick')
    #choose action = append or replace
    if action == 'append'
      @browser.label(:for => 'slidesAppend').fire_event('onClick')
    elsif action == 'replace'
      @browser.label(:for => 'slidesReplace').fire_event('onClick')
    end
    #remove style attribute
    @browser.execute_script("document.getElementsByName('qqfile')[0].removeAttribute('style')")
    sleep 2
    #set filepath based on type of file selected
    if type == "ppt"
      filefield_element.value = Dir.pwd + files_path["ppt_file1"]
      sleep 3
    elsif type == "pptx"
      filefield_element.value = Dir.pwd + files_path["pptx_file1"]
      sleep 3
    elsif type == "pdf"
      filefield_element.value = Dir.pwd + files_path["pdf_file1"]
      sleep 3
    end
    #implement counter to give timeout
    i = 0
    while upload_progress.include? 'Upload Progress'
      $stdout.print "Slides are currently Uploading\n"
      i = i+10
      sleep 10
      if i > 120
        $stdout.print "Slide upload has timed out after 120 seconds"
        i = 0
        fail
      end
    end
  end

  #Upload Video from studio
  def studio_video_upload
    DataMagic.load('default.yml')
    files_path = DataMagic.yml["path_to_test_files"]
    @browser.link(:id => 'aAddVideo').fire_event('onClick')
    sleep 2
    filefield_video_element.value = Dir.pwd + files_path["video_mp4_file"]
    sleep 3
    i = 0
    while video_upload_progress.include? 'uploaded and is now processing'
        $stdout.print "Video is currently uploaded and is now processing....\n"
        i=i+10
        sleep 10
        if i > 600
          $stdout.print "Slide upload has timed out after 10 minutes"
          i = 0
          fail
        end
    end
  end

  #changes video status to "Yes" (meaning we have uploaded a video)
  def video_status
    $video = "Yes"
    return $video
  end

  #return the status of video
  def video_status_return
    return $video
  end

  def upload_verify
    fail unless slide_timeline?
  end

  #Asserts browser in Studio Page
  def studio_go_to_permalink
    permalink_element.when_present(timeout = 15).fire_event('onClick')
  end

  #Verify that we are on studio page and handles any browser alerts
  def in_studio
    #studio_page?
    fail unless studio_page_element.when_present(timeout = 60).visible?
    #sleep inserted to wait for the alert that exists ONLY WHEN adding video content from create page
    sleep 10
    if @browser.alert.exists?
      @browser.alert.ok
    end
  end

  #Verify that we are on studio access page for presenters
  def in_studio_access_for_presenters
    #studio_page?
    fail unless studio_page_element.when_present(timeout = 60).visible?
    fail unless slide_tab_element.visible?
    @browser.execute_script("$('#user-menu').show()")
    fail "User Menu is displayed but this should be hidden for Presenters Studio Access page"
    rescue
      puts "Presenters Studio Access page is displayed properly."
  end

  #Call into studio as host
  #Extracts Host Phone number and Pin from studio
  def call_as_host
    phone_number_t = host_number_element.text.scan(/\d{1} \(\d{3}\) \d{3}-\d{4}/)
    phone_number = phone_number_t.join.gsub(" ","")
    phone_number = phone_number.gsub("(","")
    phone_number = phone_number.gsub(")","")
    phone_number = phone_number.gsub("-","")
    conf_id = conference_pin_element.text.to_s
    $stdout.print phone_number
    $stdout.print "\n"
    pin_t = host_pin_element.text.scan(/\d{3} \d{4}/)
    pin = pin_t.join.gsub(" ","")
    $stdout.print conf_id
    $stdout.print "\n"
    $stdout.print pin
    call_data = generic_call('host',phone_number,conf_id,pin)
    return call_data.to_s
  end

  #Call into studio as presenter
  #Extracts phone number and pin from confirmation email
  def call_as_presenter(phone_number, pin, conf_id)
    phone = Phone.new
    pin = pin.to_s
    phone_number = phone_number.to_s
    conf_id = conf_id.to_s
    call_data = generic_call('presenter',phone_number,conf_id,pin)
    return call_data.to_s
  end

  #Call into studio as guest with no registration
  #Extracts guest phone number from studio page
  def call_as_guest_no_pin_to_any_number(toll_free,country)
    phone_number = pick_any_guest_phone_number(toll_free,country)
    sleep 1
    conf_id = pick_guest_popup_conf_id
    call_data = generic_call('guest',phone_number,conf_id, 'no-pin')
    return call_data.to_s << "Anonymous Guest Call -  Phone Number\t\t=> #{phone_number.to_s}\nAnonymous Guest Call - Conference Id\t\t=> #{conf_id.to_s}\n\n"
  end

  def call_as_guest_no_pin_to_specific_number(number,country)
    phone_number = pick_guest_phone_number(number,country)
    sleep 1
    conf_id = pick_guest_popup_conf_id
    call_data = generic_call('guest',phone_number,conf_id, 'no-pin')
    return call_data.to_s << "Anonymous Guest Call -  Phone Number\t\t=> #{phone_number.to_s}\nAnonymous Guest Call - Conference Id\t\t=> #{conf_id.to_s}\n\n"
  end

  def pick_guest_popup_conf_id
    guest_callin_button_element.when_present.click
    sleep 1
    conf_id = @browser.elements(:css, 'div[name="popup-guestnumbers"] div.popup-block div:nth-of-type(1) ul.ng-scope li')[0].text.scan(/\d{4}/)
    conf_id = conf_id[0]
    new_guest_popup_close_button_element.click
    return conf_id
  end

  def pick_presenter_popup_conf_id
    presenter_callin_button_element.when_present.click
    sleep 1
    conf_id = @browser.elements(:css, 'div[name="popup-presenternumbers"] div.popup-block div:nth-of-type(1) ul.ng-scope li')[0].text.scan(/\d{4}/)
    conf_id = conf_id[0]
    new_presenter_popup_close_button_element.click
    return conf_id
  end

  def pick_any_guest_phone_number(toll_free,country)
    picked_number = ''
    guest_callin_button_element.when_present.click
    sleep 1
    guest_numbers = @browser.elements(:css, 'div[name="popup-guestnumbers"] div.popup-block div:nth-of-type(1) li[ng-repeat="phone in model.studioModel.GuestPhoneNumbers"]')
    json_details = Summon_Location.get_details
    country_details = Summon_Access_Line_Pool.get_country_details(country,'name',json_details)
    guest_numbers.each_with_index do |phone_number,index|
      if phone_number.text.include? country
        if toll_free == 'Toll Free'
          if phone_number.text.include? toll_free
            picked_number = guest_numbers[index].text.scan(/\d/).join('').to_i.to_s
            break
          end
        else
          picked_number = guest_numbers[index].text.scan(/\d/).join('').to_i.to_s
          break
        end
      end
    end
    new_guest_popup_close_button_element.click
    picked_number = country_details['code'].to_s + picked_number.to_s
    return picked_number
  end

  def pick_guest_phone_number(number,country)
    picked_number = ''
    extracted_number_string = ''
    guest_callin_button_element.when_present.click
    sleep 1
    guest_numbers = @browser.elements(:css, 'div[name="popup-guestnumbers"] div.popup-block div:nth-of-type(1) li[ng-repeat="phone in model.studioModel.GuestPhoneNumbers"]')
    json_details = Summon_Location.get_details
    country_details = Summon_Access_Line_Pool.get_country_details(country,'name',json_details)
    guest_numbers.each_with_index do |phone_number,index|
      extracted_number_string = phone_number.text.scan(/\d/).join('').to_i.to_s
      if extracted_number_string.include? number
        picked_number = extracted_number_string
        break
      end
    end
    new_guest_popup_close_button_element.click
    picked_number = country_details['code'].to_s + picked_number.to_s
    return picked_number
  end

  def pick_any_presenter_phone_number(toll_free,country)
    picked_number = ''
    presenter_callin_button_element.when_present.click
    sleep 1
    presenter_numbers = @browser.elements(:css, 'div[name="popup-presenternumbers"] div.popup-block div:nth-of-type(1) li[ng-repeat="phone in model.studioModel.PresenterPhoneNumbers"]')
    json_details = Summon_Location.get_details
    country_details = Summon_Access_Line_Pool.get_country_details(country,'name',json_details)
    presenter_numbers.each_with_index do |phone_number,index|
      if phone_number.text.include? country
        if toll_free == 'Toll Free'
          if phone_number.text.include? toll_free
            picked_number = presenter_numbers[index].text.scan(/\d/).join('').to_i.to_s
            break
          end
        else
          picked_number = presenter_numbers[index].text.scan(/\d/).join('').to_i.to_s
          break
        end
      end
    end
    new_presenter_popup_close_button_element.click
    picked_number = country_details['code'].to_s + picked_number.to_s
    return picked_number
  end

  def pick_presenter_phone_number(number,country)
    picked_number = ''
    extracted_number_string = ''
    presenter_callin_button_element.when_present.click
    sleep 1
    presenter_numbers = @browser.elements(:css, 'div[name="popup-presenternumbers"] div.popup-block div:nth-of-type(1) li[ng-repeat="phone in model.studioModel.PresenterPhoneNumbers"]')
    json_details = Summon_Location.get_details
    country_details = Summon_Access_Line_Pool.get_country_details(country,'name',json_details)
    presenter_numbers.each_with_index do |phone_number,index|
      extracted_number_string = phone_number.text.scan(/\d/).join('').to_i.to_s
      if extracted_number_string.include? number
        picked_number = extracted_number_string
        break
      end
    end
    new_presenter_popup_close_button_element.click
    picked_number = country_details['code'].to_s + picked_number.to_s
    return picked_number
  end

  def generic_call(call_as,phone_number,conf_id, pin)
    calling_method = FigNewton.calling_method
    case calling_method
      when "caller"
        begin
          if pin == "no-pin"
            pin = conf_id
          end
          phone_number = '+' + phone_number.to_s
          Summon_API_Client.call(call_as,phone_number,conf_id, pin)
        end
      when "twilio"
        begin
          phone = Phone.new
          phone.call "#{phone_number}"
          case call_as
            when "host"
              begin
                phone.sending_digits "wwww#{conf_id}wwwwwwwwwwww#{pin}#wwwww1"
                phone.using_default_host_voice
              end
            when "guest"
              begin
                if pin == "no-pin"
                  phone.sending_digits "wwww#{conf_id}"
                else
                  phone.sending_digits "wwww#{conf_id}wwwwwwwwwwww#{pin}#"
                end
                phone.using_default_guest_voice
              end
            when "presenter"
              begin
                phone.sending_digits "wwww#{conf_id}wwwwwwwwwwww#{pin}#"
                phone.using_default_presenter_voice
              end
            else
          end
          phone.make_call
        end
      else
    end
    return "Calling Method\t\t=> #{calling_method.to_s}\n"
  end

  #Call into studio as registered guest
  #Extracts phone number and pin from confirmation email
  def call_as_guest_with_pin(phone_number, pin, conference_id)
    pin = pin.to_s
    conf_id = conference_id.to_s
    phone_number = phone_number.to_s
    call_data = generic_call('guest',phone_number,conf_id, pin)
    return call_data.to_s
  end

  #Wait for host to appear in switchboard after calling in
  def is_host_called_in
    @browser.li(:class => 'caller ng-scope host').wait_until_present(timeout=120)
  end

  #Wait for presenter to appear in switchboard after calling in
  def is_presenter_called_in
    @browser.li(:class => 'caller ng-scope presenter').wait_until_present(timeout=120)
    $total_attend = $total_attend+1
  end

  #Wait for guest to appear in switchboard after calling in
  def is_guest_called_in
    @browser.li(:class => 'caller ng-scope').wait_until_present(timeout=120)
    $total_attend = $total_attend+1
  end

  #Show callers in studio, disabling the raised hand filter
  def check_raised_hands_filter
    check_raise_hand_filter unless raise_hand_filter_checked?
  end

  #Hide callers in studio, enabling the raised hand filter
  def uncheck_raised_hands_filter
    if raise_hand_filter_checked?
      uncheck_raise_hand_filter
    end
  end

  #Click the Go Live button to take show live
  def go_live
    i = 0
    @browser.link(:id => 'go-live').when_present(timeout=20).fire_event('onClick')
    until @browser.element(:css => 'div#timer dt.title').text.include? 'ON AIR' do
      $stdout.print "Waiting until timer panel shows ON AIR label \n"
      i =i+1
      sleep 1
      if i > 30
        $stdout.print "ON AIR label did not show on timer panel after 30 seconds"
        i = 0
        fail
      end
    end
    $status = "live"
    sleep 10
  end

  def wait_for_video(video)
    if video == "Yes"
      i = 0
      until video_processing? do
        $stdout.print "Waiting until video completes processing before calling in as host \n"
        i = i+10
        sleep 10
        if i > 600
          $stdout.print "Video upload has timed out after 10 minutes"
          i = 0
          fail
        end
      end
    end
  end

  #After show went live, click on end event
  def end_the_event
    if popup.include? "You are not connected. Please call in:"
      close_popup_element.click
      sleep 5
    else
      end_event
    end
  end

  #Confirms the end event action by clicking on the popup
  def confirm_end_event
    if popup.include? "You are not connected. Please call in:"
      close_popup_element.when_present.click
      sleep 5
    end
    end_event_confirm_element.when_present(timeout = 30).click
    $status = "finished"
    sleep 30
  end

  #DEPRECATED: Please do not use this method. Current fucntionality is for a workaround
  def wait seconds
    sleep seconds
  end

  #Click the right side arrow button in studio to push next slide
  def next_slide
    #next_slide_element.hover
    next_slide_element.fire_event('onClick')
    sleep 2
  end

  #returns link information of active ppt/pptx/video slide
  def current_slide
    img_active_slide = slide_element.attribute("src").gsub("https:", "")
    return img_active_slide
  end

  #Click the left side arrow button in studio to push to previous slide
  def previous_slide
    previous_slide_element.fire_event('onClick')
    sleep 2
  end

  #upload audio in studio
  def upload_audio
    DataMagic.load('default.yml')
    files_path = DataMagic.yml["path_to_test_files"]
    upload_audio_element.fire_event('onClick')
    sleep 5
    @browser.execute_script("document.getElementsByName('qqfile')[1].removeAttribute('style')")
    sleep 2
    filefield_audio_element.value = Dir.pwd + files_path["audio_file2"]
    sleep 5
    audio_save_element.when_present(timeout=10).click
  end

  #delete audio clips in studio
  def delete_audio_clips
    if audio_clips?
      delete_audio_element.fire_event('onClick')
      @browser.alert.ok
    else
      $stdout.print "There are no audio clips to delete at this time"
    end
  end

  #return the status of the show (preshow/live)
  def return_show_status
    return $status
  end

  #Get the caller count from studio
  def get_caller_count
    sleep 10
    #current_count = callers_element.text.scan(/\d{1}/)
    current_count = @browser.element(:id => 'caller-count').text.scan(/\d{1}/)
    current_count = current_count.fetch(0)
    return current_count
  end

  #Get the listener count from studio
  def get_listener_count
    sleep 15
    #current_count = listeners_element.text.scan(/\d{1}/)
    current_count = @browser.element(:id => 'listener-count').text.scan(/\d{1}/)
    current_count = current_count.fetch(0)
    return current_count
  end

  #Increase the caller count based on what steps taken in automation for verification
  def increase_caller_count
    $caller_count += 1
  end

  #Increase the listener count based on what steps taken in automation for verification
  def increase_listener_count
    $listener_count += 1
  end

  #return verification caller count
  def call_count
    return $caller_count
  end

  #return verification listener count
  def listen_count
    return $listener_count
  end

  #reset the counts
  def reset_count
    $caller_count = 0
    $listener_count = 0
    $video = "No"
  end

  #Compare count retrieved from studio and the count calculated based on the call count calculated
  def compare_count(count1, count2)
    if count1.to_i != count2.to_i
      sleep 15
      if count1.to_i == count2.to_i
        $stdout.print "Verified: Counter is accurate \n"
      else
      $stdout.print "Error: Counter is not accurate \n"
      fail
      end
    else
    $stdout.print "Verified: Counter is accurate \n"
    end
  end

  #Go to home page
  def go_home_page
    home_element.click
  end

  def return_permalink_encrypted_id
    encrypted_id = permalink_element.attribute_value "href"
    encrypted_id.split('/').last
  end

  #enter your host name for host and presenters chat
  def enter_host_name_for_chat(host_name)
    #chat_host_nickname_textbox_element.when_present.send_keys(host_name)
    @browser.element(:css => 'div#tab-4 input[ng-model="studioModel.presenterName"]').when_present.send_keys(host_name)
  end

  #enter host message for host and presenters chat
  def enter_host_message_for_chat(host_message)
    #chat_host_message_textbox_element.when_present.send_keys(host_message)
    #chat_host_message_textbox_element.when_present.send_keys :enter
    @browser.element(:css => 'div#tab-4 input[ng-model="model.privateChatEntry"]').when_present.send_keys(host_message)
    @browser.element(:css => 'div#tab-4 input[ng-model="model.privateChatEntry"]').when_present.send_keys :enter
  end

  #enter host message for public chat
  def enter_host_message_for_public_chat(host_message)
    #chat_host_message_textbox_element.when_present.send_keys(host_message)
    #chat_host_message_textbox_element.when_present.send_keys :enter
    @browser.element(:css => 'div#div-public-chat-container  input[ng-model="model.publicChatEntry"]').when_present.send_keys(host_message)
    @browser.element(:css => 'div#div-public-chat-container  input[ng-model="model.publicChatEntry"]').when_present.send_keys :enter
  end

  #verify host nickname for host and presenters chat
  def verify_host_nickname_for_chat(host_nickname)
    nickname_ok = false
    nicknames = @browser.elements(:css => 'div#chat-window span:nth-of-type(1)')
    nicknames.each do |nickname|
      if nickname.text.to_s == host_nickname.to_s
        nickname_ok = true
        break
      end
    end
    fail unless nickname_ok == true
  end

  #verify host message for host and presenters chat
  def verify_host_message_for_chat(host_message)
    chat_ok = false
    string1 = ''
    string2 = ''
    messages = @browser.elements(:css => 'div#chat-window span.ng-binding')
    messages.each do |message|
      string1 = message.text.to_s[2, message.text.to_s.length].to_s
      string2 = host_message.to_s
      if string1 == string2
        chat_ok = true
        break
      else
        string1 = ''
        string2 = ''
      end
    end
    fail unless chat_ok == true
  end

  #verify nickname for public chat
  def verify_nickname_for_public_chat(public_chat_nickname)
    nickname_ok = false
    string1 = ''
    string2 = ''
    nicknames = @browser.elements(:css => 'div#public-chat-window span:nth-of-type(1) b')
    nicknames.each do |nickname|
      string1 = nickname.text.to_s
      string2 = public_chat_nickname.to_s
      if string1.include?(string2)
        nickname_ok = true
        break
      else
        string1 = ''
        string2 = ''
      end
    end
    fail unless nickname_ok == true
  end

  #verify message for public chat
  def verify_message_for_public_chat(public_message)
    chat_ok = false
    string1 = ''
    string2 = ''
    messages = @browser.elements(:css => 'div#public-chat-window span.ng-binding:nth-of-type(2)')
    messages.each do |message|
      string1 = message.text.to_s[2, message.text.to_s.length].to_s
      string2 = public_message.to_s
      if string1 == string2
        chat_ok = true
        break
      else
        string1 = ''
        string2 = ''
      end
    end
    fail unless chat_ok == true
  end

  #turn on/off public chat on permalink page
  def chat_on_permalink_page_switch(value)
    if value == 'on'
      chat_on_permalink_page_on_element.when_present.fire_event('onClick')
    elsif value == 'off'
      chat_on_permalink_page_off_element.when_present.fire_event('onClick')
    end
  end

  #Select a pre-existent Poll from library and start it
  def select_and_start_poll
    #Studio Polls Manager - New Poll from Template button click...
    new_poll_from_template_button_element.when_present.fire_event('onClick')
    sleep 1
    #Studio Polls Manager - Select existing Poll...
    @browser.select_list(:xpath => "//div[@ng-model='newPollFromTemplates']/div/div/select").when_present(timeout = 15).option(:text => 'poll example multiple choice title').select
    sleep 5
    #Studio Polls Manager - Select and Edit button click...
    @browser.button(:xpath => "//div[@ng-model='newPollFromTemplates']/div/div/input").when_present.fire_event('onClick')
    #Studio Polls Manager - Save button click...
    @browser.link(:xpath => "//div[@ng-model='newPollFromTemplates']/div/div[2]/div/a[@ng-click='savePoll()']").when_present(timeout = 20).fire_event('onClick')
    #Studio Polls Manager - Start button click...
    @browser.link(:css => "div.polls-current a.btn.cta.right").when_present.fire_event('onClick')
  end

  def check_poll_option_percentage
    studio_polls_tab
    Watir::Wait.until(20) {polls_second_percentage_element.text.include? "33%"}
    fail if !polls_fourth_percentage_element.text.include? "33%"
    fail if !polls_fifth_percentage_element.text.include? "33%"
    fail if !polls_second_poll_answers_count_element.text.include? "(1 answer)"
    fail if !polls_fourth_poll_answers_count_element.text.include? "(1 answer)"
    fail if !polls_fifth_poll_answers_count_element.text.include? "(1 answer)"
  end
end