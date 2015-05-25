class BookPolicy < ApplicationPolicy

  def create? ; editor?; end
  def update? ; editor?; end   
  def destroy?; editor?; end
  def show?   ; true; end

  def collections?        ; registered? ; end  
  def manage_collections? ; registered? ; end
  def like?               ; registered? ; end
  def dislike?            ; registered? ; end
  def my?                 ; registered? ; end

  class Scope < Scope
    def resolve
      scope.all
    end
  end 

end
