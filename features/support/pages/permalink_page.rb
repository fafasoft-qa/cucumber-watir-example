#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'

class PermalinkPage

  #Local constants
  TIMEOUT = 240

  #Using libraries
	include PageObject

  #Web-elements found in Permalink Page
	div(:on_page, :id => 'maincontent')
	div(:not_started, :id => 'mediaplayer')
	#div(:slide, :class => 'popcorn-slideshow active')
  img(:slide, :css => 'div.popcorn-slideshow.active img')
	div(:vimeo, :id => 'video-container')
 	a(:viral_url, :css => 'div.marketing-link a.ng-binding')
 	div(:on_viral_page, :id => '')
  #element(:video_frame, :css => "div#video-container object param[name='flashvars']")
  param(:video_frame, :name => 'flashvars')
  div(:slide_container, :id => 'slide-container')
  div(:main_qa_box, :id => 'chat-window')
  text_field(:enter_question_text, :id => 'chat-input')
  div(:player, :id => 'media-wrapper')
  div(:viral_link, :class => 'marketing-link')
  p(:event_description, :css => 'div.description p')
  div(:poll_title, :css => 'li.poll-container div.poll-title')
  checkbox(:poll_second_option_check, :css => 'div.poll-option-container:nth-of-type(3) label.poll-option-label:nth-of-type(2) input')

  in_frame(:id => 'iframe-chat-here-embed') do |frame|
    text_field(:display_name, :id => 'username', :frame => frame)
    button(:submit_name, :value => 'Login', :frame => frame)
    text_field(:enter_text, :name => 'message', :frame => frame)
    button(:send_text, :value => 'Send', :frame => frame)
  end

  #Checks if maincontent panel in permalink page is present
	def on_permalink
    sleep 5
		while @browser.text.include? "Loading"
  	  sleep 1
    end
		on_page?
	end

  #Verify if permalink is in preshow
	def check_in_preshow
    i = 0
    while !player?
      sleep 1
      i += 1
      fail if i == 30
    end
		@browser.text.include? "This Webcast Has Not Yet Started."
	end

  def check_player
    # Wait for player to be present
    i = 0
    while !player?
      sleep 1
      i += 1
      fail if i == 30
    end
  end

  #Verify if permalink has processed the archived content
  def verify_archived_content_player_for_ended_event
    check_player
    # Check for content to be already processed
    start_time = Time.now
    while @browser.text.include? "Processing webcast"
      if Time.now - start_time > TIMEOUT
        raise RuntimeError, "Permalink page - Timed out waiting for processed archived content after #{TIMEOUT} seconds"
      end
      @browser.send_keys :f5
      on_permalink
      check_player
    end
    return "Permalink page - Archived Content Processing Time\t\t=> #{(Time.now - start_time).to_s} seconds\n"
  end

  #Verify if permalink goes straight to processing
	def check_processing
		@browser.text.include? "Processing webcast"
	end

  #Enter chatroom user/display name
	def enter_qa_question(question)
     self.enter_question_text = question
     enter_question_text.send_keys(:enter)
     sleep 2
  end

  #enter text into chat room
  def qa_available
  	fail unless main_qa_box?
  end

  #return the active ppt/pptx/video slide
  def active_slide
    i = 0
    while !player?
      sleep 1
      i += 1
      fail if i == 30
    end
    slide_exist = slide_container_element.attribute("style")
    #Checks to see if this is a ppt/pptx slide
    if slide_exist == "display: block;"
      img_active_slide = slide_element.attribute("src")
      img_active_slide = img_active_slide.gsub("https:", "")
      return img_active_slide
      #If it's not a ppt/pptx slide its a video
    else
      video_slide_html = video_frame_element.element.html
      video_frame_src = video_slide_html.scan(/view.vzaar.com/)
      video_slide_str = video_frame_src[0].to_s
      video_slide_str.empty? ? fail : video_slide_str
    end
  end

  #compare slide on permalink with the slide in studio
	def compare_slides(studio, permalink)
    $stdout.print "Studio Slide Compare: "
    $stdout.print studio.to_s
    $stdout.print "\n Permalink Slide Compare: "
    $stdout.print permalink.to_s
    $stdout.print "\n"
		fail unless studio.include?(permalink)
	end

  #click viral link
	def click_viral_link
		viral_link_element.click()
	end

	#check viral link matches the link that has been put into intranet
	def check_viral_link(actual_link)
		viral_link_url = viral_url_element.attribute("href")
    	$stdout.print "Permalink Value: "
    	$stdout.print viral_link_url
    	$stdout.print "\n Intranet Value: "
    	$stdout.print actual_link
    	$stdout.print "\n"

    	if viral_link_url == actual_link
    		$stdout.print "The viral marketing link is linked correctly \n"
    	else
    		fail
    		$stdout.print "The viral marketing link is not linked correctly \n"
    	end
	end	

	#check viral link text matches the text that has been put into the intranet
	def check_viral_text(actual_text)
		text = viral_link_element.text
		$stdout.print "Permalink Value: "
		$stdout.print text
    	$stdout.print "\n Intranet Value: "
    	$stdout.print actual_text
    	$stdout.print "\n"
    	
    	if text == actual_text
    		$stdout.print "The viral marketing link is displayed correctly \n"
    	else
    		fail
    		$stdout.print "The viral marketing link is not displayed correctly \n"
    	end
  end

  def check_event_description(expected_description)
    fail unless event_description_element.when_present(timeout = 20).text == expected_description
  end

  #verify nickname and message for public chat
  def verify_nickname_and_message_for_public_chat(nickname, public_message)
    nickname_ok = false
    chat_ok = false
    string1 = ''
    messages = @browser.elements(:css => 'div#public-chat-window td.ng-binding')
    messages.each do |message|
      string1 = message.text.to_s
      if string1.include?(nickname.to_s)
        nickname_ok = true
      end
      if string1.include?(public_message.to_s)
        chat_ok = true
        if (nickname_ok == true)
          break
        end
      else
        string1 = ''
      end
    end
    fail unless nickname_ok == true
    fail unless chat_ok == true
  end

  #enter message for public chat
  def enter_message_for_public_chat(message)
    #chat_host_message_textbox_element.when_present.send_keys(host_message)
    #chat_host_message_textbox_element.when_present.send_keys :enter
    @browser.element(:css => 'input[ng-model="publicChatEntry"]').when_present.send_keys(message)
    @browser.element(:css => 'input[ng-model="publicChatEntry"]').when_present.send_keys :enter
  end

  # vote for started poll on permalink
  def vote_for_started_poll
    fail if !poll_title_element.text.include? "poll"
    @browser.checkbox(:css => 'div.poll-option-container:nth-of-type(3) label.poll-option-label:nth-of-type(2) input').when_present.set(true)
    @browser.checkbox(:css => 'div.poll-option-container:nth-of-type(5) label.poll-option-label:nth-of-type(2) input').when_present.set(true)
    @browser.checkbox(:css => 'div.poll-option-container:nth-of-type(6) label.poll-option-label:nth-of-type(2) input').when_present.set(true)
    @browser.button(:css => "button[title='Submit your answer. You can not change it after submitting.']").when_present.fire_event('onClick')
  end
end