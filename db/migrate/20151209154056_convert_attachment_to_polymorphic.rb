# frozen_string_literal: true

class ConvertAttachmentToPolymorphic < ActiveRecord::Migration
  def change
    remove_reference :attachments, :question, index: true
    add_reference :attachments, :attachable, polymorphic: true, index: true
  end
end
