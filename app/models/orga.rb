class Orga < ActiveRecord::Base
  include Owner

  acts_as_tree(dependent: :restrict_with_exception)
  alias_method :sub_orgas, :children
  alias_method :parent_orga, :parent
  alias_method :parent_orga=, :parent=
  alias_method :sub_orgas=, :children=

  has_many :roles
  has_many :users, through: :roles
  has_many :admins, ->{where(roles: {title: Role::ORGA_ADMIN})}, through: :roles, source: :user
  has_many :locations

  has_and_belongs_to_many :categories, join_table: 'orga_category_relations'
  has_and_belongs_to_many :tags, join_table: 'tag_orga_relations'


  validates_presence_of :title
  validates_length_of :title, minimum: 5
  validates_uniqueness_of :title

  before_destroy :move_sub_orgas_to_parent, prepend: true

  def add_new_member(new_member:, admin:)
    admin.can? :write_orga_structure, self, 'You are not authorized to modify the user list of this organization!'
    if new_member.belongs_to_orga?(self)
      raise UserIsAlreadyMemberException
    else
      Role.create!(user: new_member, orga: self, title: Role::ORGA_MEMBER)
      return new_member
    end
  end

  def create_suborga(admin:, params:)
    admin.can? :write_orga_structure, self, 'You are not authorized to modify the structure of this organization!'
    title = params[:title]
    description = params[:description]
    suborga = Orga.create!(title: title, description: description)
    sub_orgas << suborga
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

  def move_sub_orgas_to_parent
    sub_orgas.each do |suborga|
       suborga.parent_orga = parent_orga
       suborga.save!
    end
    self.reload
  end

end
