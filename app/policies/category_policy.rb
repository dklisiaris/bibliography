class CategoryPolicy < ApplicationPolicy

  def show; true; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
