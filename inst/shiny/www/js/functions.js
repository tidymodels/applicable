//window.alert('alksjdf');

$(document).ready(function(){
    $("#uploaded_train_data").on('change',function(){
      $(".btn-default").css("background-color", "#5e72e4");
      $(".btn-default").css("border-color", "#5e72e4");
      $(".btn-default").css("color", "#fff");
      $(".disabled span.btn.btn-default.btn-file").css("cursor", "pointer");
    });
});
