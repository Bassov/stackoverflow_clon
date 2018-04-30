# frozen_string_literal: true

class AttachmentSerializer < ActiveModel::Serializer
  attributes :file

  def file
    object.file.url
  end
end
