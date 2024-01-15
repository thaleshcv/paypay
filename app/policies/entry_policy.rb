# frozen_string_literal: true

# Security policy for Entry resource.
class EntryPolicy < ApplicationPolicy
  def show?
    record.user_id = user.id
  end

  def edit?
    record.user_id = user.id
  end

  def update?
    edit?
  end

  def destroy?
    record.user_id = user.id
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user)
    end
  end
end
