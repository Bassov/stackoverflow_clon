# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Add comments', '
  In order to discus answer
  As an authenticated user
  I want to be able to add comments
' do
  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question }
  given(:selector) { '.answer' }

  it_behaves_like 'Acceptance commentable'
end
