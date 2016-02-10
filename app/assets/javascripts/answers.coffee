readyAnswers = ->
  questionId = $('.answers').data('questionId')

  $('.edit_answer_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show()

  $('.comment_answer_link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $('form#new_comment_answer_' + answer_id).show()

  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    attachments = $.parseJSON(data['attachments'])
    answer_question = $.parseJSON(data['answer_question'])

    $('.answers').append(JST["answers/create"]({
      answer: answer,
      attachments: attachments,
      answer_question: answer_question,
      current_user: gon.current_user
    }));

$(document).ready(readyAnswers)
$(document).on('page:load', readyAnswers)
$(document).on('page:update', readyAnswers)