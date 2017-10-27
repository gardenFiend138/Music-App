class User < ApplicationRecord
  # after_initialize :ensure_session_token
  #
  # def new
  #   render :new
  # end
  #
  # def generate_session_token
  #   self.session_token = SecureRandom.urlsafe_base64
  # end
  #
  # def reset_session_token
  #   generate_session_token
  #   self.save
  #   self.session_token
  # end
  #
  # def ensure_session_token
  #   self.session_token ||= SecureRandom.urlsafe_base64
  # end
  #
  # def password=(password)
  #   @password = password
  #   self.password_digest = BCrypt::Password.create(password)
  # end
  #
  # def is_password?(password)
  #   pass = BCrypt::Password.new(password)
  #   pass.is_password?(password)
  # end
  #
  # def find_by_credentials(email, password)
  #   user = User.find_by(email: email)
  #   return nil if user.nil?
  #   # Why do we not have to call user.password_digest here?
  #   user.is_password?(password) ? user : nil
  # end
  validates :email, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true}

  attr_reader :password
  after_initialize :ensure_session_token


  # Got this method down; it sets the password argument to an instance
  # variable, then sets the value at the current instance of user's password
  # digest to be the encrypted password.
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(@password)
  end

  # At first, I was passing password as the argument to the bcrypt method,
  # but in doing so, I was really saying, hey, take the pw that was just
  # passed to me in this method, encrypt it, then check to see if the
  # password I just passed in is the same...which will always be true...
  # Not much for validation! You need to pass the return value of self.password_digest,
  # since that will return the salted and hashed password that has been stored.
  # Makes sense.
  def is_password?(password)
    pass = BCrypt::Password.new(self.password_digest)
    pass.is_password?(password)
  end

  #this generates the session token for an instance of user; thus, it
  # must be an instance method, and not a class method. You then also
  # need to call the method session_token on self (set by attr_accessor
  # by rails).
  def generate_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

  # This does the same as above; maybe can just call generate
  # session_token, then save self, then return self's session token
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    # generate_session_token
    self.save
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def self.find_by_credentials(email, password)
    # user = User.find_by(email), doesn't work becasue find_by requires
    # a hash as an argument; why can we call is_password? on user here?
    user = User.find_by(email: email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
    # None of the below is correct; the issue with memorization.
    # Here, you need to verify that the user has input the correct
    # password.
    # if user
    #   user.save
    #   # redirect_to
    # else
    #   render :new
    # end
  end

end
