class ShelfPolicy < ApplicationPolicy

  def index?  ; shelf_belongs_to_current_user? ; end
  def show?   ; shelf_belongs_to_current_user? ; end
  def create? ; shelf_belongs_to_current_user? ; end
  def new?    ; shelf_belongs_to_current_user? ; end
  def update? ; shelf_belongs_to_current_user? ; end
  def edit?   ; shelf_belongs_to_current_user? ; end
  def destroy?; shelf_belongs_to_current_user? and not record.built_in ; end

  def public_shelves?
    if record.is_a? Symbol
      true
    else
      (record.is_public? || (record.user.profile.is_public? && record.same_as_profile?))
    end
  end
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  protected

  def shelf_belongs_to_current_user?
    return false if user.blank?

    user && (record.user == user) || record.user.profile.privacy == 'is_public'
  end
end
