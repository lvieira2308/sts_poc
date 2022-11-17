match = Match.new

Then('I should see the match screen') do
  expecting(match.match_screen?(action: :displayed), true)
  expecting(match.match_screen_welcome?(action: :displayed), true)
end

When('I click to continue with matching') do
  match.continue_matching_button(action: :click)
end

When(/^I check and interact with the (.*) container/) do |container|
  expecting(match.evaluation_container_question(container, action: :displayed),true)
  match.random_evaluation_options(container)

  step 'I click to go to the next matching container'
end

When(/^I check and interact with all evaluations/) do
  question = 1
  18.times do
    expecting(match.evaluation_container_question("evaluation_#{question}", action: :displayed),true)
    match.random_evaluation_options("evaluation_#{question}")
    step 'I click to go to the next matching container'
    question+=1

    break if match.date_birthday_field(timeout: 2, action: :displayed)
  end
end

And('I click to go to the next matching container') do
  match.next_button(action: :click)
end

Then(/^I should see the personal details screen/) do
  expecting(match.container_text('details', 'title', action: :displayed),true)
  expecting(match.container_text('details', 'subtitle', action: :displayed),true)
end
