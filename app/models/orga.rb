#TODO: autoload
require(Rails.root.join('app', 'models', 'exceptions', 'models_exceptions.rb'))

class Orga < ActiveRecord::Base

  has_many :roles
  has_many :users, through: :roles

  has_and_belongs_to_many :categories

  has_and_belongs_to_many :tags

  has_many :locations

  validates_presence_of :title
  validates_length_of :title, minimum: 5

  def add_new_member(new_member:, admin:)
    if admin.orga_admin?(self)
      if new_member.orga_member?(self)
        raise UserIsAlreadyMemberException
      else
        Role.create!(user: new_member, orga: self, title: Role::ORGA_MEMBER)
      end
    else
      raise CanCan::AccessDenied.new('user is not admin of this orga', __method__, admin)
    end
  end

end
