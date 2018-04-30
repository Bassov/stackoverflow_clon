# frozen_string_literal: true

class AddAdminForUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
  end
end
