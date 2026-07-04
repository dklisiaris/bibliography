# frozen_string_literal: true

class Admin::RedisPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def destroy?
    admin?
  end

  def stats?
    admin?
  end
end
