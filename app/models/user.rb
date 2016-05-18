class User < ActiveRecord::Base
  include Owner

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  has_many :roles
  has_many :organizations, through: :roles

  has_many :created_market_entries, class_name: 'MarketEntry', foreign_key: :creator_id

  def orga_user?(orga)
    has_role_for?(orga, Role::ORGA_USER)
  end

  def orga_admin?(orga)
    has_role_for?(orga, Role::ORGA_ADMIN)
  end

  private

  def has_role_for?(orga, role)
    belongs_to_orga?(orga) ? roles.where(organization_id: orga.id).first.try(:title) == role : false
  end

  def belongs_to_orga?(orga)
    organizations.pluck(:id).include?(orga.id)
  end

end
