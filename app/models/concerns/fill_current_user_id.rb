# frozen_string_literal: true

# Concern to fill the +user_id+ attribute with the value in +Current.user.id+,
module FillCurrentUserId
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.user_id = Current.user&.id if respond_to?(:user_id) && user_id.blank?
    end
  end
end
