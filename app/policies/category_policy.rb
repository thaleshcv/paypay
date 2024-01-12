# frozen_string_literal: true

# Policy for category resource.
class CategoryPolicy < ApplicationPolicy
  def edit?
    record_owned_by_current_user?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  class Scope < Scope
    def resolve
      Category.all
    end
  end
end
