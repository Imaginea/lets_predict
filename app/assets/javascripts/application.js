// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


$(document).ready(function(){
    $(document).on("click","[id^='team-button-'], [id^='opponent-button-']", function() {
        changeButton($(this));
    });
    $(document).on("click", "#modal-container .confirm-close-button", function(e) {
        if (confirm("Any changes will be lost. Are you sure?")) 
            $("#modal-container").hide();
        else
            e.preventDefault();
    });
    $(document).on("click", "#modal-container .close-button", function() {
      $("#modal-container").hide();
    });  

    $(".collapse").collapse()
});


function changeButton(input) {
    if(input.hasClass('cant-predict')) return false;

    var current_index = input.attr("data-index");
    var selected_team_id = input.attr("data-team-id");
    var team_button =  "#team-button-" + current_index;
    var opponent_button = "#opponent-button-" + current_index;
    var icon_team = "#team-icon-" + current_index;
    var icon_opponent = "#opponent-icon-" + current_index;

    input.attr("disabled", "true");
    input.attr("class", "btn btn-success btn-block");

    if(input.attr('id').match(/team-button-/))
    {
        $(icon_team).show();
        $(icon_opponent).hide();
        $(opponent_button).attr("class","btn btn-block");
        $(opponent_button).removeAttr("disabled");
    }
    else
    {
        $(icon_opponent).show();
        $(icon_team).hide();
        $(team_button).attr("class","btn btn-block")
        $(team_button).removeAttr("disabled");
    }
    $("#predictions_"+ current_index + "_predicted_team_id").val(selected_team_id);
};
