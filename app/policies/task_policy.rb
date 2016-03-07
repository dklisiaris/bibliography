class TaskPolicy <  Struct.new(:user, :task)
  def index?          ; admin?; end
  def update_content? ; admin?; end

  def admin?
    user and user.admin?
  end
end
