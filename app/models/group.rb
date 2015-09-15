class Group < ActiveRecord::Base
  include Joinable

  belongs_to :parent_group, class_name: 'Group', foreign_key: :group_id
  belongs_to :team

  has_and_belongs_to_many :skills

  has_many :subgroups, class_name: 'Group'

  def admin?(user)
    self_admin?(user) || team_admin?(user) || parent_group_admin?(user) || false
  end

  def member?(user)
    self_member?(user) || team_member?(user) ||
      parent_group_member?(user) || false
  end

  private

  def team_admin?(user)
    team.admin? user
  end

  def team_member?(user)
    team.member? user
  end

  def self_admin?(user)
    memberships.where(user: user).any?(&:admin?)
  end

  def self_member?(user)
    memberships.where(user: user).any?(&:member?)
  end

  def parent_group_admin?(user)
    parent_group && parent_group.admin?(user)
  end

  def parent_group_member?(user)
    parent_group && parent_group.member?(user)
  end
end
