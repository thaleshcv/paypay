# frozen_string_literal: true

# Base class for query objects.
module Queries
  class ApplicationQuery
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    def perform
      raise NotImplementedError, "Method +perform+ not implemented."
    end
  end
end
