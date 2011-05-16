$('button[class*="event_"]').click(function (e) {
  var id = $(e.currentTarget.parentNode).parent().attr('id').match(/invoice_(.*)/)[1]
  $.ajax({
    url: '/invoices/' + id + '/handle_workflow_event?event=' + e.currentTarget.classList[0].match(/event_(.*)/)[1],
    type: 'PUT',
    success: function() {
      alert(this);
    }
  });
});
