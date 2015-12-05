# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on('click', '.edit-answer', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show();
  )