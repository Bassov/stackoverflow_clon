# encoding: utf-8
# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern
  included do
    has_many :attachments, as: :attachable, dependent: :destroy
    accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
  end
end
