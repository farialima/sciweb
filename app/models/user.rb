# == Schema Information
# Schema version: 6
#
# Table name: users
#
#  id              :integer         not null, primary key
#  username        :string(20)      
#  hashed_password :string(255)     
#  salt            :string(255)     
#  nomecompleto    :string(50)      
#  created_at      :datetime        
#  updated_at      :datetime        
#

require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :username, :with => /^[a-z]+$/, :message => "inválido. Utilize apenas letras minúsculas."
  validates_presence_of :nomecompleto
  validates_uniqueness_of :nomecompleto
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  has_many :programs
  has_many :libs
  
  def validate
    errors.add_to_base("Campos de senha não podem estar em branco.") if hashed_password.blank?
  end
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def self.authenticate(name, password)
    user = self.find_by_username(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end
  
  private
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end
