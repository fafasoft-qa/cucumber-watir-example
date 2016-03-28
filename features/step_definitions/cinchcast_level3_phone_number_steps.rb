require_relative '../support/helper/level3_phone_number_api'
require_relative  '../support/helper/api_common'
Then(/^I get the phone numbers details for a "([^"]*)","([^"]*)"$/) do |carrier_name, expected_result|
  puts  Level3_API_Phone_Number_Client.get_details_per_carrier(carrier_name,expected_result)
end

Then(/^I get the phone number details for specific phone number$/) do
  data =  API_Common.get_level3_api_user_data
  test_data=  data['phone_details_data']
  test_data.each do |data| #| country_code | phone_number | toll_type | user_type | expected_result |
    config_options = data.split('|')
    country_code = config_options[0]
    phone_number = config_options[1]
    toll_type = config_options[2]
    user_type = config_options[3]
    expected_result = config_options[4]
    puts "Test Data: country code= #{country_code}, phone number = #{phone_number}, toll = #{toll_type},
          user type = #{user_type}, expected result = #{expected_result} "
    puts "test results = #{Level3_API_Phone_Number_Client.get_phone_details(country_code, phone_number, toll_type, user_type, expected_result)}"
  end
end
Then(/^I get the phone numbers details for a carrier$/) do
  data =  API_Common.get_level3_api_user_data
  test_data=  data['carrier_detais_data']
  test_data.each do |data| #| country_code | phone_number | toll_type | user_type | expected_result |
    config_options = data.split('|')
    carrier_name = config_options[0]
    expected_result = config_options[1]
    puts "Test Data: Carrier Name= #{carrier_name}, expected result = #{expected_result} "
    puts "Test results = #{Level3_API_Phone_Number_Client.get_details_per_carrier(carrier_name, expected_result)}"
  end
end
