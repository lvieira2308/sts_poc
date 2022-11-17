home = Home.new

And(/^I access the homepage/) do
  go_to_home
end

Then(/^I should be authenticated/) do
  expecting(home.signed_user_text(action: :displayed), true)
end

When('I click to find a care provider') do
  home.find_care_provider_button(action: :click)
end
