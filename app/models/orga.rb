class Orga < ActiveRecord::Base
  acts_as_tree(dependent: :restrict_with_exception)
  alias_method :suborgas, :children
  alias_method :parent_orga, :parent
  alias_method :parent_orga=, :parent=
  alias_method :suborgas=, :children=

  has_many :roles
  has_many :users, through: :roles
  has_many :admins, ->{where(roles: {title: Role::ORGA_ADMIN})}, through: :roles, source: :user
  has_many :locations

  has_and_belongs_to_many :categories, join_table: 'orga_category_relations'
  has_and_belongs_to_many :tags, join_table: 'tag_orga_relations'


  validates_presence_of :title
  validates_length_of :title, minimum: 5

  before_destroy :check_destroy_right, prepend: true
  before_destroy :move_suborgas, prepend: true

  def add_new_member(new_member:, admin:)
    admin.can? :write_orga_structure, self, 'You are not authorized to modify the user list of this organization!'
    if new_member.belongs_to_orga?(self)
      raise UserIsAlreadyMemberException
    else
      Role.create!(user: new_member, orga: self, title: Role::ORGA_MEMBER)
      return new_member
    end
  end

  def add_new_suborga(new_suborga:, admin:)
    admin.can? :write_orga_structure, self, 'You are not authorized to modify the user list of this organization!'
    if suborgas.include?(new_suborga)
      raise OrgaIsAlreadySuborgaException
    else
      suborgas << new_suborga
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
    member.can? :read_orga, self, 'You are not authorized to access the data of this organization!'
    users
  end

  def update_data(member:, data:)
    member.can? :write_orga_data, self, 'You are not authorized to modify the data of this organization!'
    self.update(data)
  end

  def change_active_state(admin:, active:)
    admin.can? :write_orga_structure, self, 'You are not authorized to modify the state of this organization!'
    self.update(active: active)
  end

  def check_destroy_right
    User.current.can? :write_orga_structure, self, 'You are not authorized to delete this organization!'
  end

  def move_suborgas
    suborgas.each do |suborga|
       suborga.parent_orga = parent_orga
       suborga.save!
    end
    self.reload
  end

end
