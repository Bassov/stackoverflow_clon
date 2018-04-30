# frozen_string_literal: true

class AddReferenseVotesToUser < ActiveRecord::Migration
  def change
    add_reference :votes, :user, index: true
  end
end
