
And(/^I select Manage registration forms from login name drop-down menu$/) do
  visit_page(RegistrationForms)
  on_page(RegistrationForms).select_manage_reg_forms
end

# Add New Form with Standard Questions
When(/^I click on Add New Form button$/) do
  on_page(RegistrationForms).click_add_new_form
end

Then(/^Manage Registration Forms page shows$/) do
 on_page(RegistrationForms).check_reg_forms_page
end

And(/^I name the form$/) do
  on_page(RegistrationForms).name_form
end

And(/^I add standard questions to the form$/) do
  on_page(RegistrationForms).select_questions
end

And(/^I save the form$/) do
  on_page(RegistrationForms).save_reg_form
end

Then(/^I see my newly created registration form listed$/) do
on_page(RegistrationForms).check_reg_form_listed
end

# Add New Form with Standard Questions required


And(/^I mark them as required$/) do
  on_page(RegistrationForms).checkbox_require
end

Then(/^I should see a little start above the question$/) do
  on_page(RegistrationForms).verify_required_question
end

# Add New Form with Standard Questions with Help Text



And(/^I type in some text in Help Text field$/) do
on_page(RegistrationForms).type_help_text
end

Then(/^I see the text right below the question$/) do
  on_page(RegistrationForms).verify_help_text
end

# Add New Form with Standard Question with Default answer


And(/^I type in some text in Default Answer$/) do
  on_page(RegistrationForms).type_default_answer
end

Then(/^I should see the text in the question field$/) do
  on_page(RegistrationForms).verify_default_answer
end


# Edit registration forms

When(/^I select a previously created registration form$/) do
  on_page(RegistrationForms).choose_reg_form
end

And(/^I can edit the Form Name$/) do
 on_page(RegistrationForms).edit_form_name
end

And(/^I select a question$/) do
  on_page(RegistrationForms).focus_on_question
end

And(/^I can mark-unmark them as required if they are not$/) do
  on_page(RegistrationForms).mark_unmark_required
end

And(/^I can edit Help Text in questions$/) do
  on_page(RegistrationForms).edit_help_text
end

And(/^I can edit Default Answer$/) do
  on_page(RegistrationForms).edit_default_answer
end

Then(/^I can check that form kept changes made$/) do
  pending # express the regexp above with the code you wish you had
end