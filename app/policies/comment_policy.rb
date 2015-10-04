class CommentPolicy < ApplicationPolicy
  def create? ; registered?              ; end
  def new?    ; registered?              ; end
  def update? ; belongs_to_current_user? ; end
  def edit?   ; belongs_to_current_user? ; end
  def destroy?; belongs_to_current_user? ; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
