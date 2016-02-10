# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
readyVotes = ->
  $('.voting').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $("##{response.klass}_#{response.id} .rating").html(response.rating)

$(document).ready(readyVotes)
$(document).on('page:load', readyVotes)
$(document).on('page:update', readyVotes)