class BookPolicy < ApplicationPolicy

  def create? ; editor?; end
  def update? ; editor?; end   
  def destroy?; editor?; end
  def show?   ; true; end

  def collections? ; registered? ; end  
  def update_collections? ; registered? ; end  

  class Scope < Scope
    def resolve
      scope.all
    end
  end 

end
