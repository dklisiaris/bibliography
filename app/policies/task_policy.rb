class TaskPolicy < ApplicationPolicy
  def index?
    admin?
  end
end
