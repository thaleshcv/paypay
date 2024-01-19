# frozen_string_literal: true

# Base class form form objects.
class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  def perform(base_scope)
    raise NotImplementedError, "Method +perform+ not implemented."
  end
end
