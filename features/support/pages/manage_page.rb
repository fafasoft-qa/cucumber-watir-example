#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'

class ManagePage

  #Using libraries
  include PageObject

  #Web-elements found in Manage Page
  li(:playlist_tab, :id => 'tab-playlists', :class => 'active')
  li(:upcoming_tab, :id => 'tab-upcoming', :class => 'active')
  li(:archived_tab, :id => 'tab-content', :class => 'active')
  
  #Asserts Playlist tab is visible
  def check_playlist_tab
    sleep 2
    fail unless playlist_tab_element.wait_until_present(timeout=20)
  end

  #Asserts Archived tab is visible
  def check_archived_tab
    sleep 2
    fail unless archived_tab_element.wait_until_present(timeout=20)
  end

  #Asserts Upcoming tab is visible
  def check_upcoming_tab
    sleep 2
    fail unless upcoming_tab_element.wait_until_present(timeout=20)
  end
end