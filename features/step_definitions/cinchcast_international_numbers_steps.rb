require_relative '../support/helper/summon_api_admin_location'
require_relative '../support/helper/summon_api_admin_access_line_pool'
require_relative '../support/helper/common'

@new_presenter_num = ''
@new_guest_num = ''

Given(/^I add two "(.*?)" and "(.*?)" phone numbers to the pool$/) do |toll_free,country|
  runtime_env = FigNewton.env
  if runtime_env != 'prod'
    if toll_free == 'Toll Free'
      toll_free = 'true'
    else
      toll_free = 'false'
    end
    json_details = Summon_Location.get_details
    country_details = Summon_Access_Line_Pool.get_country_details(country,'name',json_details)
    country_culture_code = country_details['cultureCode']
    Summon_Access_Line_Pool.access_line_pool_create(country_culture_code,'level3ams',toll_free,'2','termination_ip',json_details)
  end
end

When(/^I associate a new "(.*?)" and "(.*?)" phone number for "(.*?)"$/) do |toll_free,country,line_type|
  @numbers_before = []
  @numbers_after = []
  new_num = ''
  if toll_free == 'Toll Free'
    toll_free = 'true'
  else
    toll_free = 'false'
  end
  case line_type
    when "guest"
      line_type = "Guest"
    when "presenter"
      line_type = "Presenter"
    else
      fail "Line Type is not valid"
  end
  @numbers_before = on_page(AdminHomePage).return_phone_numbers_list
  on_page(AdminHomePage).add_phone_number_element.when_present(timeout=60).fire_event('onClick')
  on_page(AdminAddPhoneNumberPage).associate_number_save_button_element.wait_until_present(timeout=60)
  # Selecting Fake country if environment is production
  runtime_env = FigNewton.env
  if runtime_env == 'prod'
    country = 'QA (Fake Phone Numbers)'
  end
  on_page(AdminAddPhoneNumberPage).associate_phone_number(country,'ams_v5_generic',line_type,toll_free)
  on_page(AdminHomePage).check_results_list
  @numbers_after = on_page(AdminHomePage).return_phone_numbers_list
  new_num = on_page(AdminHomePage).return_new_number(@numbers_before, @numbers_after)
  line_type = line_type.upcase
  if line_type == 'PRESENTER'
    @new_presenter_num = new_num.to_s
    on_page(StudioPage).set_presenter_phone_number(@new_presenter_num.scan(/\d/).join('').to_i.to_s)
    returned_number = on_page(StudioPage).return_presenter_phone_number
    puts "Presenter phone number added\t\t=> #{returned_number.to_s}\n"
  end
  if line_type == 'GUEST'
    @new_guest_num = new_num.to_s
    on_page(StudioPage).set_guest_phone_number(@new_guest_num.scan(/\d/).join('').to_i.to_s)
    returned_number = on_page(StudioPage).return_guest_phone_number
    puts "Guest phone number added\t\t=> #{returned_number.to_s}\n"
  end
end

When(/^I disassociate both added "(.*?)" phone numbers$/) do |country|
    # Selecting Fake country if environment is production
    runtime_env = FigNewton.env
    if runtime_env == 'prod'
      country = 'QA (Fake Phone Numbers)'
    end
    on_page(AdminHomePage).find_phone_number_to_disassociate(@new_presenter_num.to_s)
    on_page(AdminAddPhoneNumberPage).associate_number_save_button_element.wait_until_present(timeout=60)
    on_page(AdminAddPhoneNumberPage).disassociate_number
    on_page(AdminHomePage).check_results_list
    on_page(AdminHomePage).find_phone_number_to_disassociate(@new_guest_num.to_s)
    on_page(AdminAddPhoneNumberPage).associate_number_save_button_element.wait_until_present(timeout=60)
    on_page(AdminAddPhoneNumberPage).disassociate_number
    on_page(AdminHomePage).check_results_list
end
