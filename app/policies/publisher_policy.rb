class PublisherPolicy < ApplicationPolicy

  def search?; true; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
