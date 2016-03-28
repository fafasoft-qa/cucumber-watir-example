#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'

#Helper class.
module Common

include PageObject
include DataMagic

  # method for waiting until ajax elements finishes loading
  # parameter 'how': selector method. i.e.: :id
  # parameter 'what': what to find regarding selector method.
  def self.wait_until_ready(how, what, desc = '', timeout = 5)
    msg = "wait_until_ready: element: #{how}=#{what}"
    msg << " #{desc}" if desc.length > 0
    proc_exists  = Proc.new { @browser.elements(how, what)[0].exists? }
    proc_enabled = Proc.new { @browser.elements(how, what)[0].enabled? }
    start = Time.now.to_f
    if Watir::Wait.until(timeout) { proc_exists.call }
      if Watir::Wait.until(timeout) { proc_enabled.call }
        stop = Time.now.to_f
        puts "#{__method__}: start:#{"%.5f" % start} stop:#{"%.5f" % stop}"
        puts "#{msg} (#{"%.5f" % (stop - start)} seconds)"
        true
      else
        puts msg
      end
    else
      failed_to_log(msg)
    end
  rescue
    puts "Unable to #{msg}. '#{$!}'"
    raise RuntimeError, "Unable to #{msg}. '#{$!}'"
  end

  def self.get_test_data(file, key, value)
    DataMagic.load(file)
    data = DataMagic.yml[key]
    return data[value]
  end

  def self.wait_for_new_window(browser, window_title, time_out)
    browser.window(:title => "#{window_title}").wait_until_present(timeout = time_out)
    rescue
      puts "Timeout after #{time_out} waiting for window to load. Title: #{window_title}'#{$!}'"
      raise RuntimeError, "Timeout after #{time_out} waiting for window to load. Title: #{window_title}'#{$!}'"
  end

  def self.get_file_name_from_path(path)
    if path.to_s.include?('/')
      file_name = path.to_s.split('/').last
    else
      file_name = path.to_s.split('\\').last
    end
    file_name = file_name.split('.').first
    return file_name
  end
end