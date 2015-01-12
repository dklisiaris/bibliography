class ProfilePolicy < ApplicationPolicy
  
  def show?           ; belongs_to_current_user? or (record.privacy == 0 and not record.username.nil?)  ; end
  def update?         ; belongs_to_current_user?                                                        ; end
  def edit?           ; belongs_to_current_user?                                                        ; end

  private

  def belongs_to_current_user?
    user and (record.user == user)
  end


  class Scope < Scope
    def resolve
      scope
    end
  end

end
