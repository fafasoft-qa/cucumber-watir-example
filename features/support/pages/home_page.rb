#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'
require_relative '../helper/common'

class HomePage
  #Using libraries
  include PageObject
  include DataMagic

  #Web-elements found in Home Page
  li(:check_event, :css => 'ul#upcoming-events li.content-item')
  li(:check_archived_view, :css => 'div#content-list-items li.content-item')
  a(:delete_event, :class => "btn small delete")
  a(:reporting, :class => 'btn small graph')
  div(:homepage, :id => 'maincontent')
  a(:manage, :class => 'dropdown link-manage')
  link(:archived, :link => "Archived Content")
  link(:upcoming, :link => "Live And Upcoming Events")
  link(:playlist, :link => "Playlists")
  a(:studio, :class => 'btn cta')
  li(:first_archived, :class => 'content-item')
  a(:edit, :class => 'btn small edit')
  div(:actions, :class => 'actions')
  a(:copyURL, :id => 'aCopyUrl')
  a(:enter_studio, :css => 'a[title^="Go to studio"]')
  link(:new_end_confirm, :id => "btn-end-confirm")
  link(:end_show, :link => "End Event")  
  a(:home, :href => '/')
  div(:popup, :class => 'popup-block')
  link(:close_popup, :link => 'End the Event')
  div(:manage, :class => 'content-list-items')
  a(:live_upcoming_titles, :css => 'li.content-item span.title')
  a(:first_live_upcoming_titles, :css => '.content-item span.title a.preview')
  a(:first_live_event, :css => ".content-item span.status a[title='Go to studio (this event is LIVE!)']")

# Account Info section
  h3(:account_info_title, :css => 'div.box-header h3')

  def check_account_info_section
    # Account Info Title
    DataMagic.load('default.yml')
    account_info_title = Common.get_test_data("default.yml","dashboard_account_info_data","title")
    if !account_info_title_element.text.include?(account_info_title)
      fail "Account Info section title is empty or wrong."
    end
    # Call Info Labels
    call_info_labels = @browser.elements(:css => '#right-side-content .box .table dt')
    call_info_labels.each do |call_info_label|
      case call_info_label.text
        when /#{Common.get_test_data("default.yml","dashboard_account_info_data","host_call_in_label")}/
        when /#{Common.get_test_data("default.yml","dashboard_account_info_data","host_pin_label")}/
        when /#{Common.get_test_data("default.yml","dashboard_account_info_data","presenter_call_in_label")}/
        when /#{Common.get_test_data("default.yml","dashboard_account_info_data","guest_call_in_label")}/
        else
        fail "Account Info: a label is empty or wrong. Valid values are: Host call-in, Host pin, Presenter call-in, Guest call-in."
      end
    end
      # Call Info Numbers
      call_info_numbers = @browser.elements(:css => '#right-side-content .box .table dd')
      call_info_numbers.each do |call_info_number|
        call_info_number_str = call_info_number.text.gsub!(/\D/, "")
        if call_info_number_str.length == 0
          fail "Account Info: a phone number or pin is empty. Check manually Account Info numbers for this test user."
        end
      end
  end

  #removes upcoming events
  def remove_upcoming
    #checks to see if an event exists
    sleep 5
    @browser.ul(:id => 'upcoming-events').wait_until_present(timeout = 60)
    while !@browser.text.include? "You have no upcoming events scheduled." do
      #checks status id of show. 9 = live 6 = preshow
      statusID = check_event_element.when_present(timeout = 30).attribute('statid')
      #if show is live we want to go into the studio and end the live show from inside of the studio
      if statusID.to_i == 9
        enter_studio_element.fire_event('onClick')
        #wait for studio to load and for the pop up to happen (if it does)
        sleep 15
        #if the host is no longer called in this pop up will occur, this allows us to close the popup
        if popup.include? "You are not connected. Please call in:"
          close_popup_element.click
        else
          end_show
        end
        new_end_confirm
        sleep 15
        home_element.click
        @browser.ul(:id => 'upcoming-events').wait_until_present(timeout = 60)
        #if the show is not live, we can manually delete it from the home page
      else
        #mimics hover method but works for firefox browser
        sleep 15
        if !@browser.text.include? "You have no upcoming events scheduled."
          @browser.execute_script("document.getElementsByClassName('actions')[0].style.visibility = 'visible'")
          delete_event_element.when_present.click
          @browser.alert.ok
        end
      end
      sleep 60
    end
  end

  #chose create event via create page or the 'new event button'
  def create_event(how)
    if how == 'New Event'
      @browser.link(:id => 'button-broadcast').click
      sleep 3
    elsif how == 'Create'
      @browser.link(:id => 'createlink').click
      sleep 3
    end 
  end

  #check to make sure on home page
  def check_homepage
    sleep 5
    fail unless check_event_element.when_present(timeout = 30).visible?
  end

  #check to make sure on Archived view
  def check_archived_view
    sleep 5
    fail unless check_archived_view_element.when_present(timeout = 30).visible?
  end

  #navigate to the reporting page from hover button
  def go_to_reporting
    if check_event?
      #hover
      @browser.execute_script("document.getElementsByClassName('actions')[0].style.visibility = 'visible'")
      reporting_element.when_present(timeout = 30).click
    end
  end

  def get_event_index_by_title(event_title)
    event_index = nil
    if check_event?
      if @browser.element(:css => 'li.content-item span.title').when_present(timeout = 10)
        events = @browser.elements(:css => 'li.content-item span.title')
        events.each_with_index do |event_item,index|
          if event_item.text == event_title
            event_index = index + 2
            break
          end
        end
      end
    end
    return event_index
  end

  #go into studio
  def go_to_studio(event_title)
    event_index = get_event_index_by_title(event_title)
    @browser.element(:css => "li.content-item:nth-of-type(" + event_index.to_s + ") span.status a.btn i.icon-microphone").fire_event('click')
  end

  #edit archived webcast
  def go_edit_archived_webcast
    #hover
    @browser.execute_script("document.getElementsByClassName('actions')[0].style.visibility = 'visible'")
    edit_element.when_present(timeout = 30).click
  end

  #edit upcoming webcast
  def go_edit_upcoming_webcast
    #hover
    if check_event?
      @browser.execute_script("document.getElementsByClassName('actions')[0].style.visibility = 'visible'")
      edit_element.when_present(timeout = 30).click
    end
  end

  #extract reporting link URL
  def get_reporting_link(event_title)
    reportURL = nil
    event_index = get_event_index_by_title(event_title)
    #hover
    @browser.execute_script("document.getElementsByClassName('actions')[" + (event_index - 2).to_s + "].style.visibility = 'visible'")
    reportURL = @browser.element(:css => "li.content-item:nth-of-type(" + event_index.to_s + ") div.actions a.btn.small.graph").when_present(timeout = 2).attribute_value('href')
    $stdout.print reportURL
    $stdout.print "\n"
    return reportURL
  end

  #delete archived event
  def delete_archived_event(event_title)
    event_index = get_event_index_by_title(event_title)
    #hover
    @browser.execute_script("document.getElementsByClassName('actions')[" + (event_index - 2).to_s + "].style.visibility = 'visible'")
    @browser.element(:css => "li.content-item:nth-of-type(" + event_index.to_s + ") div.actions a.btn.small.delete").when_present(timeout = 2).fire_event('click')
    @browser.alert.ok
  end

  #extract permalink URL
  def get_permalinkURL
    @browser.execute_script("document.getElementsByClassName('actions')[0].style.visibility = 'visible'")
    permalinkURL = copyURL_element.when_present(timeout = 30).href
    $stdout.print permalinkURL
    return permalinkURL
  end

  #goes to archived content via drop down menu
  def manage_archived
    #manage_element.hover
    @browser.execute_script("$('#manage-menu').show()")
    archived_element.when_present(timeout = 30).click
  end

  #goes to upcoming content via drop down menu
  def manage_upcoming
    #manage_element.hover
    @browser.execute_script("$('#manage-menu').show()")
    upcoming_element.when_present(timeout = 30).click
  end

  #goes to playlist content via drop down menu
  def manage_playlist
    #manage_element.hover
    @browser.execute_script("$('#manage-menu').show()")
    playlist_element.when_present(timeout = 30).click
  end

  def go_event_access_page
    @browser.execute_script("$('#user-menu').show()")
    @browser.link(:href => '/EventAccess').when_present(timeout = 30).fire_event('onClick')
  end

  def signout_from_cinchcast
    @browser.execute_script("$('#user-menu').show()")
    @browser.link(:href => '/Account/LogOff').when_present(timeout = 30).fire_event('onClick')
    sleep 5
  end
end