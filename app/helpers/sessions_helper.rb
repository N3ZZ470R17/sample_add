module SessionsHelper
    # Inicia sesion al usuario
    def log_in(user)
        session[:user_id] = user.id
    end

    # Regresa el usuario que haya iniciado sesion al token de la cookie recordada
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    # Cierra sesion del usuario logueado
    def log_out
        forget(current_user)
        reset_session
        @current_user = nil
    end

    # Recuerda al usuario en una sesión permanente
    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    # Olvida una sesion permanente
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # Retorna verdadero si el usuario esta "logueado", de lo contrario es falso
    def logged_in?
        !current_user.nil?
    end

    # Retorna verdadero si el usuario dado es el usuario actual
    def current_user?(user)
        user && user == current_user
    end

    # Almacena la URL al que intenta acceder.
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

end
