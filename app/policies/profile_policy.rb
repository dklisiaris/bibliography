class ProfilePolicy < ApplicationPolicy

  def show?   ; belongs_to_current_user? or public? ; end
  def update? ; belongs_to_current_user?            ; end
  def edit?   ; belongs_to_current_user?            ; end

  def follow?
    registered? && public?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

  protected

  def public?
    record[:privacy] == 'is_public' && record.username.present?
  end
end
