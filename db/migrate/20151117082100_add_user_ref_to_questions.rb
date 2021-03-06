# frozen_string_literal: true

class AddUserRefToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :user, index: true
  end
end
