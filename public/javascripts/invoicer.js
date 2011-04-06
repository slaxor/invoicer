(function ($) {
  var user_id = location.pathname.match('/users/([0-9A-Fa-f]+)')[1];
  var base_path = '/users/' + user_id;
  $(function () { //doc ready
    setTimeout(function () {$('#flash_message').remove()}, 5000);
    $('#destroy_session').click(function () {
      $.ajax({
        url: '/user_session/123',
        type: 'DELETE',
        success: function() {
          location = '/user_session/new';
        }
      })
    });

    $('#user_settings').click(function () {location.pathname = '/users/' + user_id + '/edit'});

    //$('button[class*="edit_"],button[class*="show_"],button[class*="destroy_"],button[class*="create_"]').
    $('.action button').
      live('click', function () {
        var $button = $(this)
        var id_parts = $button.attr('id').split('_');
        var id = id_parts[id_parts.length -1];
        var controller = 'brauch ich den?';
        var action = id_parts[0];
        var click_handler = {
          edit: function () {
            console.log('edit');
          },
          show: function () {
            console.log('show');
          },
          destroy: function () {
            $.ajax({
              url: location.pathname + '/' + id + '.json',
              type: 'DELETE',
              success: function() {
                $button.parents('tr').remove()
              }
            })
          },
          create: function () {}
        };
        click_handler[action]();
    });

  });
})(jQuery)

