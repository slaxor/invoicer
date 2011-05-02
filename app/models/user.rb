class User
  include Mongoid::Document
  field :database_authenticatable
  field :confirmable
  field :recoverable
  field :rememberable
  field :trackable
  field :timestamps
  attr_accessible :database_authenticatable, :registerable, :token_authenticatable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable, :timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable

  references_many :customers, :dependent => :delete_all
  references_many :invoicing_parties, :dependent => :delete_all

  mount_uploader :avatar, AvatarUploader

  def invoices
    self.customers.map(&:invoices).flatten
  end
end
