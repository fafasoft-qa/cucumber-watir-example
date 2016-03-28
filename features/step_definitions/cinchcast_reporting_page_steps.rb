require_relative '../support/helper/common'

Then (/^I check the summary values$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "reporting_title"), 30)
  on_page(ReportingPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "reporting_title"))
  page_view = on_page(ReportingPage).registration_page_views
  puts "Reporting Page - Number of Registration Page Views\t\t=> #{page_view.to_s}\n"
  total_reg = on_page(ReportingPage).total_registrant
  puts "Reporting Page - Total number of Registrants\t\t=> #{total_reg.to_s}\n"
  total_attend = on_page(ReportingPage).total_attended
  puts "Reporting Page - Total number of Registrants who Attended\t\t=> #{total_attend.to_s}\n"
  reg_attend = on_page(ReportingPage).registrant_attended
  puts "Reporting Page - Percentage of Registrants who attended\t\t=> #{reg_attend.to_s}\n"
end

Then (/^I check the value of Total Registration Page Views$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "reporting_title"), 30)
  on_page(ReportingPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "reporting_title"))
  page_view = on_page(ReportingPage).registration_page_views
  puts "Reporting Page - Total Page Views\t\t=> #{page_view.to_s}\n"
  view_count = on_page(RegistrationPage).return_page_view
  puts "Actual Calculated Page Views\t\t=> #{view_count.to_s}\n"
  on_page(ReportingPage).compare_values(page_view ,view_count)
end

Then (/^I check the value of Total Registrations$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "reporting_title"), 30)
  on_page(ReportingPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "reporting_title"))
  total_reg = on_page(ReportingPage).total_registrant
  puts "Reporting page - Total Registrations\t\t=> #{total_reg.to_s}\n"
  reg_count = on_page(RegistrationPage).total_registration
  puts "Actual Calculated Total Registrations\t\t=> #{reg_count.to_s}\n"
  on_page(ReportingPage).compare_values(total_reg,reg_count)
end

Then (/^I check the value of Total Attended$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "reporting_title"), 30)
  on_page(ReportingPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "reporting_title"))
  status = on_page(StudioPage).return_show_status
  total_attend = on_page(ReportingPage).total_attended
  puts "Reporting page - Total Attended\t\t=> #{total_attend.to_s}\n"
  attend_count = on_page(RegistrationPage).total_attended(status)
  puts "Actual Calculated Total Attended\t\t=> #{attend_count.to_s}\n"
  on_page(ReportingPage).compare_values(total_attend,attend_count)
end

Then (/^I check the Percentage of Registrants who Attended$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "reporting_title"), 30)
  on_page(ReportingPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "reporting_title"))
  status = on_page(StudioPage).return_show_status
  reg_attend = on_page(ReportingPage).registrant_attended
  puts "Reporting page - Percentage Attended\t\t=> #{reg_attend.to_s}\n"
  reg_count = on_page(RegistrationPage).total_registration
  attend_count = on_page(RegistrationPage).total_attended(status)
  percent = on_page(ReportingPage).calculate_percent(attend_count, reg_count)
  puts "Actual Calculated Percentage Attended\t\t=> #{percent.to_s}\n"
  on_page(ReportingPage).compare_values(reg_attend, percent)
end

Then (/^I check Duration for calls$/) do
  Common.wait_for_new_window(@browser, Common.get_test_data("default.yml","page_title_data", "reporting_title"), 30)
  on_page(ReportingPage).attach_to_window(:title => Common.get_test_data("default.yml","page_title_data", "reporting_title"))
  on_page(ReportingPage).check_duration
end