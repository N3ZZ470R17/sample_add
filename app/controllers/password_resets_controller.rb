class PasswordResetsController < ApplicationController
  # #####
  # Contexto Case <<=== Casos de restablecimiento de claves:
  #   Case (1): Restablecimiento expirado.
  #   Case (2): Update fallido por una contraseña invalida.
  #   Case (3): Update fallido (presuntamente exitosa) debido a una clave y su confirmacion vacias.
  #   Case (4): Update exitoso.
  # #####
  
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Caso (1)

  def new
    
  end

  def edit
    
  end

  def update
  if params[:user][:password].empty? # Case (3)
    @user.errors.add(:password, "No puede quedar vacio")
    render 'edit'
  elsif @user.update(user_params) # Case (4)
    log_in @user
    @user.update_attribute(:reset_digest, nil)
    flash[:success] = "Clave restablecida."
    redirect_to @user
  else # Case (2)
    render 'edit'
  end
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Un correo electronico fue enviado con las instrucciones correspondientes para el restablecimiento de la clave"
      redirect_to root_url
    else
      flash.now[:danger] = "Correo electronico no encontrado"
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

  # Before filters
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirma un usuario si es valido
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end    

    # Comprueba la expiracion del token de restablecimiento
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Expirado el restablecimiento de clave"
        redirect_to new_password_reset_url
      end
    end

end
