class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        # Inicia sesión y lo redirecciona a la pagina de vista del usuario
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        message = "Cuenta no activada"
        message += "Verifica en tu buzon para el enlace de activacion"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Crea un mensaje de error
      flash.now[:danger] = 'Combinacion invalida de email y contraseña'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
