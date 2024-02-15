# frozen_string_literal: true

# Base class for query objects.
class ApplicationQuery
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment

  def perform
    raise NotImplementedError, "Method +perform+ not implemented."
  end
end
