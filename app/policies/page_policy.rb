class PagePolicy <  Struct.new(:user, :page)
  def welcome_guide? ; registered?; end

  private
  def registered?
    user.present?
  end
end
