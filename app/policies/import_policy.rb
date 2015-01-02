class ImportPolicy <  Struct.new(:user, :import)
  def index?; admin?; end

  def admin?
    user and user.admin?
  end
end
