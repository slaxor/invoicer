//=require 'lib/ajaxupload.js'
new AjaxUpload('user_avatar', {
  action: $('form').attr('action') + '.json',
  method: 'put',
  name: 'user_avatar',
  onComplete : (file) ->
    $('<p></p>').appendTo($('#user_avatar')).text(file)
  })


