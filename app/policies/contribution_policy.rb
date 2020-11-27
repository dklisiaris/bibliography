class ContributionPolicy < ApplicationPolicy
  def index
    false
  end

  class Scope < Scope
    def resolve
      if user && (user.role == 'editor' || user.role == 'admin')
        scope.all
      else
        scope.where(id: nil)
      end
    end
  end
end
