# encoding: utf-8
# frozen_string_literal: true

class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  validates :file, presence: true

  mount_uploader :file, FileUploader
end
