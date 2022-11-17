signin = Signin.new

And('I input my email {string} and password {string}') do |email, password|
  signin.email_field(action: :send_keys, keys: email)
  signin.password_field(action: :send_keys, keys: password)
end

When('I click to sign in') do
  signin.signin_button(action: :click)
end
