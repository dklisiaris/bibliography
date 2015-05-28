class AuthorPolicy < ApplicationPolicy
  
  def favourite?; registered? ; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
