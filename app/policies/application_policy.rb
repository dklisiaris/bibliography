class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # The General Application policy is let editing to editors.

  def index?  ; true                                    ; end
  def show?   ; scope.where(:id => record.id).exists?   ; end
  def create? ; editor?                                 ; end
  def new?    ; create?                                 ; end
  def update? ; editor?                                 ; end
  def edit?   ; update?                                 ; end
  def destroy?; editor?                                 ; end
  def scope   ; Pundit.policy_scope!(user, record.class); end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  protected

  def editor?
    user && (user.role == 'editor' || user.role == 'admin')
  end

  def belongs_to_current_user?
    user && (record.user == user)
  end

  def registered?
    user.present?
  end
end
