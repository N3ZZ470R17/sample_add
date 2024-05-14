require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:rodney)
    @another_user = users(:alex) # Segundo usuario para evitar accesos no autorizados
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  # Redirigir al index cuando no esta "logueado"
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # Debe redirigir del edit si no ha iniciado sesión

  test "should redirect edit when not logged in" do
    get edit_user_path(@another_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # Debe redirigir del update si no ha iniciado sesión

  test "should redirect update when not logged in" do
    patch user_path(@another_user), params: {user: { name: @user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # Redirección destroy sin logueo
  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # Redireccion destroy con logueo pero sin admin
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@another_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
