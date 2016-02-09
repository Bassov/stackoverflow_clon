# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  PrivatePub.subscribe '/questions', (data, channel) ->
  question = $.parseJSON(data['question'])
  $('.questions tbody').append("<tr><td><a href=/questions/#{question.id}>#{question.title}</a></td></tr>")

  $('.comment_question_link').click (e) ->
  e.preventDefault();
  question_id = $(this).data('questionId')
  $('form#new_comment_question_' + question_id).show()