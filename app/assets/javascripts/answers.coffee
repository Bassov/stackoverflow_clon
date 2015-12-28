ready = ->
  $('.edit_answer_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show()

#  questionId = $('.answers').data('questionId')
#  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
#    console.log(data)
#    answer = $.parseJSON(data['answer'])
#    $('.answers').append('<p>' + answer.body + '</p>')
#    $('.answers').append('<p><a href="#">Edit</a></p>')
#    $('.new_answer #answer_body').val('');

  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    object = $.parseJSON(xhr.responseText)
    $('.answers').append(JST["answers/create"]({response: object, current_user: gon.current_user}));

  $('.voting').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $("#" + response.klass + "_" + response.id + " .rating").html(response.rating)

$(document).ready(ready)
#$(document).on('page:load', ready)
#$(document).on('page:update', ready)