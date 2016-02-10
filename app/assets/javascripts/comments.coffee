# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
readyComments = ->
  questionId = $('.answers').data('questionId')

  # POST#create
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    klass = comment.commentable_type.toLowerCase()

    $("##{klass}_comments_#{comment.commentable_id}").append(JST["comments/create"](comment: comment));

$(document).ready(readyComments)
$(document).on('page:load', readyComments)
$(document).on('page:update', readyComments)