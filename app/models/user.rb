class User < ActiveRecord::Base
    #Доступные атрибуты для изменения через веб
    attr_accessor :password
    attr_accessible :name, :email, :password, :password_confirmation

    has_many :posts, :dependent => :destroy #уничтожение сообшений пользователя вместе с пользователем

    #Регулярные выражения
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    #Валидация атрибутов
    validates :name,     :presence => true,
                         :length => { :within => 6..20 },
                         :uniqueness => { :case_sensitive => false }

    validates :email,    :presence => true,
                         :format => {:with => email_regex },
                         #уникальность игнорирующая регистр
                         :uniqueness => { :case_sensitive => false }

    validates :password, :presence => true,
                         #автоматически создает виртуальный атрибут password_confirmation
                         :confirmation => true,
                         :length => { :within => 6..40 }

    before_save :encrypt_password

  #Сравнение зашифрованной версии подтверждаемого (отправляемого) пароля с (зашифрованным) паролем данного пользователя
   def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
   end

  #Добавляем метод User.authenticate
   def self.authenticate(name, submitted_password)
   user = find_by_name(name)
   return nil if user.nil?
   return user if user.has_password?(submitted_password)
   end

#authenticate_with_salt вначале ищет пользователя по уникальному id, а затем проверяет что соль, хранящаяся в cookie является правильной для этого пользователя.
   def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil  if user.nil?
    return user if user.salt == cookie_salt
   end

    private

    #Перед сохранением в бд зашифровываем пароль
    def encrypt_password
      self.salt = make_salt if new_record? #Если новая запись добавляем соль
      self.encrypted_password = encrypt(password)
    end
    #Шифрование с соль
    def encrypt(string)
      secure_hash("#{salt}---#{string}")
    end

    #Формируем соль
    def make_salt
      secure_hash("#{Time.now.utc}---#{password}")
    end

    #Шифруем пароль библиотекой SHA2
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

