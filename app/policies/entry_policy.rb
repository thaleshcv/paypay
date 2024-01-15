# frozen_string_literal: true

# Security policy for Entry resource.
class EntryPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    true
  end

  def update?
    edit?
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user)
    end
  end
end
