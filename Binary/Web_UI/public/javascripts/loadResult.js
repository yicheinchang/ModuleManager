$( document ).ready(function() {
  $('.action_button').click(function(event) {
    event.preventDefault();
    $('#StatusModal').modal('toggle');
    $("#modal-content").html('');
    $("#closeModal").hide();
    var path=$(this).attr("module_path");
    var act=$(this).attr("module_act");
    $.ajax({
      url: "/ServiceManage",
      data: {
        module_path: path,
        module_action: act
      },
      type: "POST",
      //dataType : "text",
      success: function( text ) {
        $("#modal-content").html(text);
        $('#StatusModal').modal('show');
        $("#closeModal").show();
      },
      error: function( xhr, status, errorThrown ) {
        $("#modal-content").html(errorThrown);
        $('#StatusModal').modal('show');
        $("#closeModal").show();
        console.log(errorThrown);
      }//,
/*
      complete: function( xhr, status ) {
        console.log( "The request is complete!" );
      }
*/
    });
  });
});
