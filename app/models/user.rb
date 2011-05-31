class User
  include Mongoid::Document
  field :email
  field :login
  field :password
  field :database_authenticatable
  field :confirmable
  field :recoverable
  field :rememberable
  field :trackable
  field :avatar
  attr_accessible :email, :login, :password,:database_authenticatable, :registerable,
    :token_authenticatable, :confirmable, :recoverable, :rememberable, :trackable,
    :validatable, :lockable, :avatar

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable, :token_authenticatable


  references_many :customers, :dependent => :delete_all
  references_many :invoicing_parties, :dependent => :delete_all

  mount_uploader :avatar, AvatarUploader

  def invoices
    self.customers.map(&:invoices).flatten
  end
end
