require 'watir-webdriver'
require 'os'
require_relative 'helper/file_utils'
require_relative 'helper/common'

include DataMagic

# Global variables
$login_data = {}
$current_feature_path = ''
$current_alternative_login_level = 0
$event_title = nil
$reportingURL = nil
$reg_views = 0
$total_reg = 0
$total_attend = 0
$reg_attend = 0
$status = "preshow"
$current_feature_name = ''

#  Get current time
time = Time.new
# converts current time into 'YYYY-MM-DD/HH.mm.ss' format to be used throughout the application
$date_and_time = "#{time.year}-#{time.month}-#{time.day}/#{time.hour}.#{time.min}.#{time.sec}"

#Path and file for the log output
if OS.windows?
  LOG_FILE = Dir.pwd + '\\log\\chromedriver.log'
else
  LOG_FILE = Dir.pwd + '/log/chromedriver.log'
end
# Up the http client's timeout to 90 seconds
client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 90 # seconds – default is 60

#  Before each scenario, run
Before do |scenario|
  # Selects browser according to default.yml
  runtime_browser = FigNewton.browser
  case runtime_browser
    when "chrome"
      browser = Watir::Browser.new :chrome, :http_client => client, :service_log_path => LOG_FILE
    when "localchrome"
      begin
        browser = Watir::Browser.new :chrome, :switches => %w[--accept-ssl-certs --ignore-certificate-errors --disable-popup-blocking --disable-translate --allow-running-insecure-content --ignore-certificate-errors]
      end
    when "firefox"
      begin
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile.native_events = false
        browser = Watir::Browser.new :firefox, :profile => profile, :http_client => client
      end
    when "ie"
      begin
        # Up the implicit wait for ie to 1 minute
        browser = Watir::Browser.new :ie, :http_client => client
        browser.driver.manage.timeouts.implicit_wait = 60
      end
    when "debug"
      begin
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile.assume_untrusted_certificate_issuer = false
        profile.add_extension "features/support/ff_extensions/firebug-1.12.1-fx.xpi","firebug"
        #profile.add_extension "features/support/ff_extensions/firefinder_for_firebug-1.4-fx.xpi","firefinder"
        profile.add_extension "features/support/ff_extensions/firepath-0.9.7-fx.xpi","firepath"
        profile["extensions.firebug.currentVersion"] = "999"
        profile["extensions.firepath.currentVersion"] = "999"
        #        profile["extensions.firefinder.currentVersion"] = "999"
        profile["extensions.firebug.allPagesActivation"] = "off"
        ['console', 'net', 'script'].each do |feature|
          profile["extensions.firebug.#{feature}.enableSites"] = true
        end
        profile["extensions.firebug.previousPlacement"] = 3
        profile.native_events = true
        browser = Watir::Browser.new :firefox, :profile => profile
      end
    else browser = Watir::Browser.new :chrome , :http_client => client, :service_log_path => LOG_FILE
  end

  @browser = browser

  puts "BROWSER\t\t=> #{runtime_browser.to_s}\n"
  runtime_env = FigNewton.env
  puts "SERVER\t\t=> #{runtime_env.to_s}\n"
  env_prefix = FigNewton.env_prefix


  #DataMagic.load('default.yml')

  upcoming_feature_file = ''
  upcoming_feature_file = scenario.feature.file

  # For each different feature check if an alternative login user is required (0: not required)
  if upcoming_feature_file != $current_feature_path
    $current_feature_path = upcoming_feature_file
    $current_feature_name =  Common.get_file_name_from_path($current_feature_path)

    $current_alternative_login_level = Common.get_test_data("login_data.yml",env_prefix+"_alternative_login_user_level", $current_feature_name)
    case $current_alternative_login_level
      when 0
        $login_data = DataMagic.data_for 'login_data/'+env_prefix+'_login_success'
      when 1
        $login_data = DataMagic.data_for 'login_data/'+env_prefix+'_login_success_alt_1'
      when 2
        $login_data = DataMagic.data_for 'login_data/'+env_prefix+'_login_success_alt_2'
      when 3
        $login_data = DataMagic.data_for 'login_data/'+env_prefix+'_login_success_alt_3'
      else
        $login_data = DataMagic.data_for 'login_data/'+env_prefix+'_login_success'
      #fail 'alternative login user level number should be a number between 0,1,2,3'
    end
  end

  puts "USERNAME\t\t=> #{$login_data['username'].to_s}\n"

  #Maximize browser window.
  @browser.driver.manage.window.maximize
end

# After each scenario, run
After do |scenario|
  #Resetting variables
  $reg_views = 0
  $total_reg = 0
  $total_attend = 0
  $reg_attend = 0
  $caller_count = 0
  $listener_count = 0
  $video = "No"

  #begin and ensure make certain that the browser window is closed, disregarding an error in the take screenshot method
  begin
    if scenario.failed?
      take_screenshot(scenario)
    end
      # Terminate instance of browser
  ensure
    #@browser.close
    # improve disposal of browsers
    @browser.quit
  end
end

#  Private methods
private

#  Takes a screenshot of the current state of the page if the scenario failed.
#  Saves screenshot in folder specified in environments/default.yml
def take_screenshot(scenario)
  screenshot_dir = "#{FigNewton.screenshot_directory}/#{$date_and_time}"
  screenshot_dir_html = "#{FigNewton.screenshot_directory_html}/#{$date_and_time}"
  File_Utils.mkdir screenshot_dir unless File.directory? screenshot_dir
  # Creates filename for screenshot from scenario's name
  screenshot = "#{screenshot_dir}/FAILED_#{scenario.name.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')}.png"
  screenshot_html = "#{screenshot_dir_html}/FAILED_#{scenario.name.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')}.png"
  @browser.driver.save_screenshot(screenshot)
  # Embeds screenshot into Cucumber HTML reports
  embed screenshot_html, 'image/png'
end