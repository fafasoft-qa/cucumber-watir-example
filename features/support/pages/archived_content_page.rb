#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'
require_relative '../helper/common'

class ArchivedContentPage
  #Using libraries
  include PageObject
  include DataMagic

  #Local constants
  TIMEOUT = 600

  #Web-elements found in Archived Content Page
  a(:first_archived_content_title, :css => '.content-item span.title a.preview')
  a(:permalink_link, :class => 'permalink')
  a(:download, :class => 'btn small download')
  video(:mp3_player, :css => 'video')

  def click_on_permalink_link
    permalink_link_element.click
  end

  #Checks if maincontent panel in permalink page is present
  def on_download_mp3_page
    mp3_player_element.wait_until_present(timeout = 30)
  end

  def verify_embed_player_present_for_last_archived_event
    first_archived_content_title_element.wait_until_present(timeout = 30)
    if first_archived_content_title_element.text.include? $event_title
      first_archived_content_title_element.click
      sleep 10
      start_time = Time.now
      while !@browser.element(:id => 'singleplayer').present?
        if Time.now - start_time > TIMEOUT
          raise RuntimeError, "Archived content view - Timed out waiting for processed archived content after #{TIMEOUT} seconds"
        end
        @browser.send_keys :f5
        fail unless @browser.li(:id => 'tab-content', :class => 'active').wait_until_present(timeout=30)
        first_archived_content_title_element.when_present(timeout=30).click
        sleep 10
      end
      return "Archived Content View - Archived Content Processing Time\t\t=> #{(Time.now - start_time).to_s} seconds\n"
    end
  end

  #click on Download mp3 button
  def download_archived_mp3
    #hover
    @browser.execute_script("document.getElementsByClassName('actions')[0].style.visibility = 'visible'")
    download_element.when_present(timeout = 30).click
  end
end