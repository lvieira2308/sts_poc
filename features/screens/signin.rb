class Signin < Bridge

  ##################################### ELEMENTS #####################################

  def sign_up_link(action: :none)
    find_element_by(".SignInForm__StyledLink-sc-1dsrg76-6.ekuWOx", action: action)
  end

  def email_field(action: :none, keys: :none)
    find_element_by("[name='email']", action: action, keys: keys)
  end

  def password_field(action: :none, keys: :none)
    find_element_by("[name='password']", action: action, keys: keys)
  end

  def signin_button(action: :none)
    find_element_by("[type='submit']", action: action)
  end



end
