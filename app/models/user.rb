# -*- encoding : utf-8 -*-
require 'digest/sha2'

class User
  include Mongoid::Document

  references_many :customers, :dependent => :delete_all
  references_many :invoicing_parties, :dependent => :delete_all
  references_many :invoices, :through => :customers
  mount_uploader :avatar, AvatarUploader

  field :login
  field :email
  field :crypted_password
  field :password_salt
  field :api_keys
  field :session_id

  attr_accessible :login, :email, :password, :api_keys, :session_id

  def password=(password)
    salt = rand(2**160)
    self.crypted_password = (Digest::SHA1.hexdigest(password).to_i(16)^salt).to_s(16)
    self.password_salt = salt.to_s(16)
  end

  def authentic?(password)
    (Digest::SHA1.hexdigest(password).to_i(16)^self.password_salt.to_i(16)).to_s(16) == self.crypted_password
  end

  def api_user(key)
    self.api_keys[key]
  end

  def generate_api_key(service)
     self.api_keys[rand(2**512).to_s(16)] = service
  end
end
