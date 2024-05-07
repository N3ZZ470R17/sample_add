require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Inicio | Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Ayuda | Ruby on Rails Tutorial Sample App"
  end
  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "Acerca de... | Ruby on Rails Tutorial Sample App"
  end

  test "should get contact" do
   get static_pages_contact_url
   assert_response :success
   assert_select "title", "Contacto | Ruby on Rails Tutorial Sample App"
  end
end
