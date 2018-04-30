# frozen_string_literal: true

class AnswersListSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
end
