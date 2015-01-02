class BookPolicy < ApplicationPolicy

  def create? ; editor?; end
  def update? ; editor?; end   
  def destroy?; editor?; end
  def show    ; true; end   

  class Scope < Scope
    def resolve
      scope.all
    end
  end 

end
