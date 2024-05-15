class UsersController < ApplicationController
  
  # Se coloca el only: para evitar que lo aplique en CADA acción, actuando solamente en las acciones que se especifiquen.
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update] # Segundo usuario para evitar accesos no autorizados
  before_action :admin_user, only: :destroy # <== Destroy solo para los usuarios admins.

  # Accion de "show" buscando por :id como parametro del metodo find
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    #debugger (Depuracion en consola del servidor de Rails)
  end
  
  # Index

  def index
    @user = User.paginate(:page => params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuario eliminado"
    redirect_to users_url
  end

  def create
    @user = User.new(user_params) # Implementacion incompleta
    if @user.save
      @user.send_activation_email
      flash[:info] = "Mira tu buzon para activar tu cuenta"
      redirect_to root_url
    else
      # flash[:error] = "Something went wrong"
      render 'new'
    end
  end
  
  def update
    if @user.update(user_params)
      # Maneja una actualización (update) exitosa
      flash[:success] = "Perfil actualizado"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    # # # Ya aplicado en application_controller.rb
    # # Confirma un usuario ya "logueado"
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Inicia sesión para continuar"
    #     redirect_to login_url        
    #   end
    # end

    # Confirma un usuario autorizado
    def correct_user
      @user = User.find(params[:id])
      redirect_to (root_url) unless current_user?(@user) # <<== Refactorizado bajo metodo booleano para mejor "expresividad"       
      end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
