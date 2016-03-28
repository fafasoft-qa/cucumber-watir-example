#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'

class ReportingPage
  include PageObject
  #include WatirPageHelper

  div(:on_page, :id => 'report')
  table(:audience_table, :id => 'regUsers')
  table(:summary_table, :class => 'table kpi-table')
  #td(:total_attend, :id => 'registrant-attend-count')
  #td(:reg_attended, :id => 'registrant-attend-percentage')
  #row(:audience_table_header) { | audience_table | audience_table.tr}
  #cell(:audience_table_header_email) { | audience_table_header | audience_table_header.td}
  #cell(:audience_table_header_first) { | audience_table_header | audience_table_header.td(:index => 1)}
  #cell(:audience_table_header_last) { | audience_table_header | audience_table_header.td(:index => 2)}
  #cell(:audience_table_header_usertype) { | audience_table_header | audience_table_header.td(:index => 3)}
  #cell(:audience_table_header_attended) { | audience_table_header | audience_table_header.td(:index => 4)}
  #cell(:audience_table_header_duration) { | audience_table_header | audience_table_header.td(:index => 6)}
  #cell(:audience_table_header_info) { | audience_table_header | audience_table_header.td(:index => 7)}

  $compare_failed = false

  EMAIL = 0
  FIRST = 1
  LAST = 2
  USERTYPE = 3
  ATTENDED = 4
  DURATION = 5
  INFO = 6

  #Verify if on the reporting page
  def on_reporting_page
    fail unless on_page?
    sleep 3
  end

  #Gets the value of registration page views
  def registration_page_views
    summary_table_element[1][0].text
    #	$stdout.print views
  end

  #Gets the value of the total guests registered
  def total_registrant
    summary_table_element[1][1].text
    #$stdout.print total
  end

  #Gets the value of total attended for a show
  def total_attended
    summary_table_element[1][2].text
    #$stdout.print total
  end

  #Gets the value of the number of registered users that attended
  def registrant_attended
    summary_table_element[1][3].text
    #$stdout.print attended
  end

  #Compares values of reporting page versus counters to make sure the elements display correct number
  def compare_values(value1, value2)
    if value1.to_i == value2.to_i
      $stdout.print "Values on Reporting Page are Accurate\n"
    elsif value1.to_i != value2.to_i
      $stdout.print "The values on Reporting Page are not Accurate\n"
      fail "Values on Reporting page are not accurate"
    end
  end

  #Gets percentage given 2 values (needed for summary table)
  def calculate_percent(value1, value2)
    percent = ((value1.to_f/value2.to_f)*100).round
    percent = percent.to_s+"%"
    return percent
  end

  #Search through rows in table
  def audience_row_number(number)
    #row = audience_table_element.tr(:index => number)
    row = @browser.table(:id => 'regUsers').tr(:index => number)
    return row
  end

  #Search through columns in table
  def audience_column_number(number)
    i = number.to_i-1
    #column = audience_table_element.td(:index => i)
    column = @browser.table(:id => 'regUsers').td(:index => i)
    return column
  end

  #Usings row/column numbers to find a particular element value in the table
  def audience_table_cell(row, column)
    cell = audience_table_element[row.to_i][column.to_i].text
    #cell = @browser.table(:id => 'regUsers')[row.to_i][column.to_i]
    return cell
  end

  def check_duration
    durations = @browser.elements(:css => 'td.registrant-duration')
    durations.each do |duration|
      fail unless duration.text.strip != "00:00:00" "Duration is zero for caller in Reporting page"
    end
  end
end