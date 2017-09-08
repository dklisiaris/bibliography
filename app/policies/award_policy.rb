class AwardPolicy < ApplicationPolicy
  def index?  ; editor? ; end
  def show?   ; editor? ; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
