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
  include DeviseTokenAuth::Concerns::User

  has_many :roles
  has_many :orgas, through: :roles

  has_many :created_market_entries, class_name: 'MarketEntry', foreign_key: :creator_id

  def orga_member?(orga)
    has_role_for?(orga, Role::ORGA_MEMBER)
  end

  def orga_admin?(orga)
    has_role_for?(orga, Role::ORGA_ADMIN)
  end

  def create_user_and_add_to_orga(email:, forename:, surname:, orga:)
    if orga_admin?(orga)
      new_user = User.create!(email: email, forename: forename, surname: surname, password: 'abc12345')
      orga.add_new_member(new_member: new_user, admin: self)
    else
      raise CanCan::AccessDenied.new('user is not admin of this orga', __method__, self)
    end
  end

  def leave_orga(orga)
    unless belongs_to_orga?(orga)
      raise ActiveRecord::RecordNotFound.new('user not in orga!')
    end
    roles.where(organization: orga, user: self).delete_all
  end

  def remove_user_from_orga(member:, orga:)
    unless orga_admin?(orga)
      raise CanCanCan::AccessDenied.new('no permission to remove user')
    end
    member.leave_orga(orga)
  end

  class << self
    def current
      @user
    end

    def current=(user)
      @user = user
    end
  end

  private

  def has_role_for?(orga, role)
    belongs_to_orga?(orga) ? roles.where(orga_id: orga.id).first.try(:title) == role : false
  end

  def belongs_to_orga?(orga)
    orgas.pluck(:id).include?(orga.id)
  end

end
