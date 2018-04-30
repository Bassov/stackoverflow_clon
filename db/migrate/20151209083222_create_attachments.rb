# frozen_string_literal: true

class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.belongs_to :question, index: true

      t.timestamps null: false
    end
  end
end
