# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
readyQuestions = ->
  questionId = $('.answers').data('questionId')

  # POST#create
  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions tbody').append(JST["questions/create"](question: question));

  $('.comment_question_link').click (e) ->
    e.preventDefault();
    question_id = $(this).data('questionId')
    $('form#new_comment_question_' + question_id).show()

$(document).ready(readyQuestions)
$(document).on('page:load', readyQuestions)
$(document).on('page:update', readyQuestions)
