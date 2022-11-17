class Home < Bridge

  ##################################### ELEMENTS #####################################

  def signed_user_text(action: :none)
    find_element_by(".usn-name", action: action)
  end

  def find_care_provider_button(action: :none)
    find_by_text("Find My Care Provider", action: action, button: true)
  end
end
