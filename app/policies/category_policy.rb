class CategoryPolicy < ApplicationPolicy

  def show?     ; true        ; end
  def favourite?; registered? ; end 

  class Scope < Scope
    def resolve
      scope
    end
  end
end
