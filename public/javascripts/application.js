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
//$('input[type="datetime"]').datepicker({showAnim: 'slideDown', showButtonPanel: true, dateFormat: 'dd.mm.yyyy', numberOfMonths: 3,
  //showCurrentAtPos: 1
//})

//$('.invoice_items input').change(function(e) {alert(e)})

  var oneDay = 24*60*60*1000;
  var rangeDemoFormat = "%e-%b-%Y";
  var rangeDemoConv = new AnyTime.Converter({format:rangeDemoFormat});
  $("#rangeDemoToday").click( function(e) {
      $("#rangeDemoStart").val(rangeDemoConv.format(new Date())).change(); } );
  $("#rangeDemoClear").click( function(e) {
      $("#rangeDemoStart").val("").change(); } );
  $("#rangeDemoStart").AnyTime_picker({format:rangeDemoFormat});
  $("#rangeDemoStart").change( function(e) { try {
      var fromDay = rangeDemoConv.parse($("#rangeDemoStart").val()).getTime();
      var dayLater = new Date(fromDay+oneDay);
      dayLater.setHours(0,0,0,0);
      var ninetyDaysLater = new Date(fromDay+(90*oneDay));
      ninetyDaysLater.setHours(23,59,59,999);
      $("#rangeDemoFinish").
          AnyTime_noPicker().
          removeAttr("disabled").
          val(rangeDemoConv.format(dayLater)).
          AnyTime_picker(
              { earliest: dayLater,
                format: rangeDemoFormat,
                latest: ninetyDaysLater
              } );
      } catch(e){ $("#rangeDemoFinish").val("").attr("disabled","disabled"); } } );


$('input[type="datetime"]').AnyTime_picker(
      { format: "%H:%i", labelTitle: "Zeit",
        labelHour: "Stunde", labelMinute: "Minute" } );

