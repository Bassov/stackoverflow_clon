# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Объявляем функцию ready, внутри которой можно поместить обработчики событий и другой код, который должен выполняться при загрузке страницы
ready = ->
# Это наш обработчик, перенесенный сюда из docuement.ready ($ ->)
  $('.edit_answer_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show()

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    console.log(data)
    answer = $.parseJSON(data['answer'])
    $('.answers').append('<p>' + answer.body + '</p>')
    $('.answers').append('<p><a href="#">Edit</a></p>')
    $('.new_answer #answer_body').val('');

#  Здесь могут быть другие обработчики событий и прочий код
  $('.voting').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $("#" + response.klass + "_" + response.id + " .rating").html(response.rating)

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update