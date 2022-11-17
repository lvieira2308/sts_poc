class Match < Bridge

  ##################################### ELEMENTS #####################################

  def initialize
    @form = YAML.load_file('features/screens/match_form.yml')
  end

  def match_screen?(action: :none)
    find_element_by('.sc-0-ContinueMatching__Center-sc-94np0o-0', action: action)
  end

  def match_screen_welcome?(action: :none)
    find_by_text('Welcome to matching!', action: action)
  end

  def continue_matching_button(action: :none)
    find_by_text('Continue with matching', action: action, button: true)
  end

  def container_text(title, type, action: :none)
    find_by_text(@form[title][type], action: action)
  end

  def evaluation_container_question(title, action: :none)
    find_by_text(@form[title]['question'], action: action)
  end

  def random_evaluation_options(title, action: :none)
    type = @form[title]['type']
    if type.eql?('slider')
      rand(1..10).times { generic_slider(action: action, keys: :arrow_right) }
    elsif type.eql?('radio')
      generic_radio_buttons.sample.click
    else
      elements = generic_checkboxes
      elements.each_with_index do |el,index|
        index == 1 ? el.click : el.click if [true, false].sample
      end
    end
  end

  def generic_checkboxes(action: :none)
    find_elements_by('.ms-checkbox', action: action)
  end

  def generic_radio_buttons(action: :none)
    find_elements_by('[role="radio"]', action: action)
  end

  def generic_slider(action: :none, keys: :none)
    find_element_by('.rs-slider-handle', action: action, keys: keys)
  end

  def next_button(action: :none)
    find_by_text('Next', action: action, button: true)
  end

  def date_birthday_field(action: :none, keys: :none, timeout: 30)
    find_element_by('[name="dob"]', action: action, keys: keys, timeout: timeout)
  end

  def address_street_field(action: :none, keys: :none)
    find_element_by('[name="address.street"]', action: action, keys: keys)
  end

  def address_street_field_2(action: :none, keys: :none)
    find_element_by('[name="address.alternate_street"]', action: action, keys: keys)
  end

  def address_city_field(action: :none, keys: :none)
    find_element_by('[name="address.city"]', action: action, keys: keys)
  end

  def phone_field(action: :none, keys: :none)
    find_element_by('[name="primary_phone_number.number"]', action: action, keys: keys)
  end

  def gender_field(action: :none, keys: :none)
    find_element_by('react-select-2-placeholder', by: :id, action: action, keys: keys)
  end

  def province_field(action: :none, keys: :none)
    find_element_by('react-select-3-placeholder', by: :id, action: action, keys: keys)
  end

  def zip_code(action: :none, keys: :none)
    find_element_by('[name="address.code"]', action: action, keys: keys)
  end

  def emergency_contact_name_field(action: :none, keys: :none)
    find_element_by('[name="emergency_contact.name"]', action: action, keys: keys)
  end

  def emergency_contact_relationship_field(action: :none, keys: :none)
    find_element_by('[name="emergency_contact.relationship"]', action: action, keys: keys)
  end

  def emergency_contact_phone_field(action: :none, keys: :none)
    find_element_by('[name="emergency_contact.phone"]', action: action, keys: keys)
  end

  def select_practitioner_button(action: :none)
    find_by_text('Select Practitioner', button: true, action: action)
  end

  def verify_phone_later_button(action: :none)
    find_by_text('I want to verify my phone number later.', button: true, action: action)
  end

  def agree_btn_1(action: :none)
    find_element_by(".SingleCheckBoxContent__StyledCheckBox-sc-4hk1mq-1", action: action)
  end

  def agree_btn_2(action: :none)
    find_element_by(".SingleCheckBoxContent__StyledContainer-sc-4hk1mq-0", action: action)
  end

  def submit(action: :none)
    find_element_by("[type='submit']", action: action)
  end

  def message_sent_text(action: :none)
    find_by_text('Your care provider has been messaged!', action: action)
  end

end