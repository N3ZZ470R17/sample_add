require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:rodney)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # Correo invalido
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Correo valido
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Formulario de reset de clave
    user = assigns(:user)
    # Correo erroneo
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Usuario inactivo
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Correo correcto, token erroneo
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Correo y token correctos
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Contraseña invalida y su confirmacion
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: "foobaz", password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # Contraseña vacia / en blanco
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: "", password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # Contraseña y confirmacion validas
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: "foobaz", password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end


end
