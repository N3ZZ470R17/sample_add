class UsersController < ApplicationController
  # Accion de "show" buscando por :id como parametro del metodo find
  def show
    @user = User.find(params[:id])
    #debugger (Depuracion en consola del servidor de Rails)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Implementacion incompleta
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Bienvenido a Sample Add!"
      redirect_to @user
    else
      # flash[:error] = "Something went wrong"
      render 'new'
    end
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
