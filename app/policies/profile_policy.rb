class ProfilePolicy < ApplicationPolicy
  
  def show?   ; belongs_to_current_user? or public? ; end  
  def update? ; belongs_to_current_user?            ; end
  def edit?   ; belongs_to_current_user?            ; end
  def follow? ; registered? and public?             ; end


  class Scope < Scope
    def resolve
      scope
    end
  end

  protected

  def public?
    record[:privacy] == 0 and not record.username.nil?
  end

end
