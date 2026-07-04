class ImportPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def import_stuff?
    admin?
  end
end
