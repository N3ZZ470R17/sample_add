class ApplicationController < ActionController::Base
  include SessionsHelper
  # def hello
  #   render html: "hello, world!"
  # end

  private
    
    # Confirma un usuario logueado
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Por favor inicie sesión"
        redirect_to login_url
      end
    end
    
end
