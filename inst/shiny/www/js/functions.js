//window.alert('alksjdf');

$(document).ready(function(){
    $("#uploaded_train_data").on('change',function(){
      $(".btn-default").css("background-color", "#5e72e4");
      $(".btn-default").css("border-color", "#5e72e4");
      $(".btn-default").css("color", "#fff");
      $(".disabled span.btn.btn-default.btn-file").css("cursor", "pointer");
    });

    $("#uploaded_test_data").on('change',function(){
      /*
      if ($('#uploaded_test_data_progress').css("visibility") == "hidden"){
        $("#tab-models").css("background-color", "#d0d1d6");
        $("#tab-models").css("color", "#ededed");
        $("#tab-models").css("cursor", "no-drop");
      }
      else {
      */
        $("#tab-models").css("background-color", "#fff");
        $("#tab-models").css("color", "#5e72e4");
        $("#tab-models").css("cursor", "pointer");
      //}
    });
});
