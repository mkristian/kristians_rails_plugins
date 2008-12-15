require 'digest/sha2'
class BaseUser

  def self.login_property_name
    :login
  end

  def password_length
    8
  end

  # Authenticates a user by their login name and password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = first(self.login_property_name => login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Digests some data with the salt.
  def self.digest(login, password, salt)
    Digest::SHA256.hexdigest("--#{login}--#{salt}--#{password}--")
  end

  def authenticated?(password)
    #puts "\nlogin\t: #{login}\npwd\t: #{password}\ndigest\t: #{digest(password)}\nsalt\t: #{salt}\n"
    digest = digest(password)
    if self.temp_hashed_password == digest
      self.hashed_password = self.temp_hashed_password
      self.temp_hashed_password = nil
      true
    else
      self.temp_hashed_password = nil
      self.hashed_password == digest
    end
  end

  def digest(password)
    self.class.digest(login, password, salt)
  end

  def self.generate_password(len)
    # A-Z starting with 97 and having 26 characters
    # a-z starting with 65 and having 26 characters
    # 0-9 starting with 48 and having 10 characters
    # TODO make this class constance
    offset=[[26,97], [26,65], [10,48]]
    
    # collect 'len' random characters from the either of the above ranges
    begin
      #TODO use secure random somehow !!!
      pwd = (1..len).collect { (j= Kernel.rand(3); i = Kernel.rand(offset[j][0]); i += offset[j][1]).chr }.join
    end while !((pwd =~ /[a-z]/) && (pwd =~ /[A-Z]/) && (pwd =~ /[0-9]/))
    pwd
  end

  def reset_password
    pwd = BaseUser.generate_password(password_length)
    self.password = pwd
    self.password_confirmation = pwd
  end

  def password_required_for_validation?
    # validation is needed when the password was never digested
    # FIXME the NULL check is needed for sqlite3
    hashed_password.blank? or hashed_password == "'NULL'" or 
      # validation is NOT needed when the user comes from the database
      # i.e. password == nil and hashed_password != nil
      !(password.nil? and !hashed_password.blank?)
    #true
  end

  # before filter 
  def digest_password
    return if (password.nil? or password == '')
    self.salt = Digest::SHA256.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
     if self.hashed_password.nil?
       self.hashed_password = digest(password)
     else
       self.temp_hashed_password = digest(password) 
    end
  end
end
