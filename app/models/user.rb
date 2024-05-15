class User < ApplicationRecord
  # Relacionado con micropublicaciones
  has_many :microposts, dependent: :destroy

  # Sesiones
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest 
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence:true, length: { minimum: 6 }, allow_nil: true

  # Retorna el hash digest de una cadena dada
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Retorna token aleatorio
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Recuerdame?!
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Olvidame!!
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Retorna verdadero si dicho token corresponde al digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activa una cuenta
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Envia correo de activacion
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Ajusta atributos de restablecimiento de claves
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Envia un correo para restablecer clave
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now  
  end

  # Retorna verdadero si un reset de clave ha expirado
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # #### Area de micropublicaciones (microposts)
  # Define un proto-feed
  # Implementacion completa (Cap 14 ~ Final)
  def feed
    Micropost.where("user_id = ?", id)
  end

  private

    # Todo correo en minusculas
    def downcase_email
      self.email = email.downcase
    end

    # Crea y asigna el token y el digest de la activacion de un correo electronico
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
