Given(/^I am at the Login Page$/) do
  visit_page(LoginPage)
end

Given(/^I set the staging environment if enabled$/) do
  if FigNewton.staging_switch == "enabled"
    if FigNewton.env == 'prod.cwebcast.com'
      on_page(LoginPage).wl_enable_staging
    end
    on_page(LoginPage).enable_staging
  end

  end

When(/^I sign into cinchcast using username as "(.*?)" and password as "(.*?)"$/) do |username, password|
  on_page(LoginPage).login_success('username' => username ,'password' => password)
end

When(/^I sign into cinchcast$/) do
  on_page(LoginPage).login_success($login_data)
end

When(/^I sign into cinchcast with just created account$/) do
  on_page(LoginPage).login_with_just_created_account
end

When(/^I signout from cinchcast$/) do
  on_page(HomePage).signout_from_cinchcast
end

When(/^I sign into cinchcast with no username$/) do
  on_page(LoginPage).no_username
end

When(/^I sign into cinchcast with incorrect data$/) do
  on_page(LoginPage).incorrect_login
end

When(/^I sign into cinchcast with no password$/) do
  on_page(LoginPage).no_password
end

Then(/^I should be on homepage$/) do
  on_page(HomePage).check_homepage
end

Then(/^I should see an error for login$/) do
  on_page(LoginPage).login_fail
end

Then(/^I should see an error for username$/) do
  on_page(LoginPage).check_username_fail
end

Then(/^I should see an error for password$/) do
  on_page(LoginPage).check_password_fail
end
