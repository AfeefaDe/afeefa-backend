class Orga < ActiveRecord::Base

  has_many :roles
  has_many :users, through: :roles
  has_many :locations

  has_and_belongs_to_many :categories, join_table: 'orga_category_relations'
  has_and_belongs_to_many :tags, join_table: 'tag_orga_relations'


  validates_presence_of :title
  validates_length_of :title, minimum: 5

  def add_new_member(new_member:, admin:)
    if admin.orga_admin?(self)
      if new_member.belongs_to_orga?(self)
        raise UserIsAlreadyMemberException
      else
        Role.create!(user: new_member, orga: self, title: Role::ORGA_MEMBER)
        return new_member
      end
    else
      raise CanCan::AccessDenied.new('user is not admin of this orga', __method__, admin)
    end
  end

  def add_new_suborga(new_suborga:, admin:)
    if admin.orga_admin?(self)
      if suborgas.include?(new_suborga)
        raise OrgaIsAlreadySuborgaException
      else
        suborgas << new_suborga
      end
    else
      raise CanCan::AccessDenied.new('user is not admin of this orga', __method__, admin)
    end
  end

  def list_members(member:)
    if member.belongs_to_orga?(self)
      return users
    else
      raise CanCan::AccessDenied.new('user is not member of this orga', __method__, member)
    end
  end

end
