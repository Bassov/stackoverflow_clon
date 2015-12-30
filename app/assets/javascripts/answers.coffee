ready = ->
  $('.edit_answer_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show()

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    attachments = $.parseJSON(data['attachments'])
    console.log(attachments)
    rating = $.parseJSON(data['rating'])
    answer_question = $.parseJSON(data['answer_question'])
    answer_class = $.parseJSON(data['answer_class'])

    $('.answers').append(JST["answers/create"]({
      answer: answer,
      attachments: attachments,
      answer_question: answer_question,
      rating: rating,
      answer_class: answer_class,
      current_user: gon.current_user
    }));

    $('.new_answer #new-answer-body').val('')

#  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
#    object = $.parseJSON(xhr.responseText)
#    $('.answers').append(JST["answers/create"]({response: object, current_user: gon.current_user}));

  $('.voting').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $("#" + response.klass + "_" + response.id + " .rating").html(response.rating)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)