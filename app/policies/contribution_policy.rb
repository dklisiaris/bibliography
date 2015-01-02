class ContributionPolicy < ApplicationPolicy  
  def index; false; end

  class Scope < Scope
    def resolve
      if (user and (user.editor? or user.admin?))
        scope.all
      else
        scope.where(:id => nil)
      end
    end
  end
end
