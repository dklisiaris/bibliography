class ShelfPolicy < ApplicationPolicy

  def index?  ; belongs_to_current_user? ; end
  def show?   ; belongs_to_current_user? ; end
  def create? ; belongs_to_current_user? ; end
  def new?    ; belongs_to_current_user? ; end
  def update? ; belongs_to_current_user? ; end
  def edit?   ; belongs_to_current_user? ; end
  def destroy?; belongs_to_current_user? and not record.built_in ; end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end