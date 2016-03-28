require 'rubygems'
require 'watir-webdriver'

class RegistrationForms
  include PageObject
  include DataMagic

  $form_name = nil

#selects manage registration forms from login name drop-down menu
  def select_manage_reg_forms
    #@browser.link(:id => 'username').hover
    # a hack because latest webdriver can't work with native event (e.g. hover) in Firefox
    @browser.execute_script("$('#username').show()")
    sleep 3
    @browser.link(:href => '/Registration/ListSetups').fire_event('onClick')
  end

  def click_add_new_form
    @browser.link(:class => 'btn cta right').click
  end

  def check_reg_forms_page
    fail'Registration page has not been displayed' unless @browser.divs(:class => 'box-header', :text => 'Registration Forms')
  end

  def name_form
    #  Get current time
    time = Time.new
# converts current time into 'YYYY-MM-DD/HH.mm.ss' format to be used throughout the application
    $date_and_time = "#{time.year}-#{time.month}-#{time.day}/#{time.hour}.#{time.min}.#{time.sec}"
    $form_name = "Testing with Automation #{$date_and_time}"
    @browser.text_field(:id => 'new-template-name').set $form_name
  end

  def select_questions
      @browser.link(:id => 'FirstName').click
      @browser.link(:href => '#addField').click
      @browser.link(:id => 'LastName').click
      @browser.link(:href => '#addField').click
      @browser.link(:id => 'ZipCode').click
  end

  def  save_reg_form
      @browser.button(:id => 'save').fire_event('onClick')
  end

  def check_reg_form_listed
    @browser.screenshot.save 'screenshot.png' if !@browser.divs(:id => 'save_success', :text => 'Saved')
  end

  def checkbox_require
     @browser.checkbox(:id => 'field.required').set
  end

  def verify_required_question
    #fail 'Question failed to be mark as required' unless !@browser.divs(:class => 'ctrlHolder ctrlHolderSelected', :label => '*')
    fail 'Question failed to be mark as required' unless @browser.ems(:text => '*')
  end

  def type_help_text
    @browser.text_field(:id => 'field.description').set ('please complete above')
   end

  def verify_help_text
    @browser.divs(:class => 'formHint', :text => 'please complete above')
  end

  def type_default_answer
    @browser.text_field(:id => 'field.value').set ('Default Answer for this test')
  end

  def verify_default_answer
    fail('Default Question has not been set') unless !@browser.text.include?('Default Answer for this test')
  end

  def choose_reg_form
    @browser.link(:text => $form_name).click
  end

  def edit_form_name
    @browser.text_field(:id => 'new-template-name').set ('edited')
  end

  def focus_on_question
    @browser.input(:class =>'textInput').fire_event('onClick')
  end

  def edit_default_answer
    @browser.text_field(:id => 'field.value').set ('Default Answer edited')
  end

  def edit_help_text
    @browser.text_field(:id => 'field.description').set ('help text edited')
  end

  def mark_unmark_required
    @browser.checkbox(:id => 'field.required').set
  end
end

