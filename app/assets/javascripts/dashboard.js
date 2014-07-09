$(document).ready(function(){
    $("#phone_numbers").tokenInput(data,{
        hintText: "Enter phone number",
        noResultsText: "No number found",
        searchingText: "Searching...",
        propertyToSearch: "phone",
        preventDuplicates: true
    });

    $("#message").keyup(function () {
        var i = $("#message").val().length;
        $("#counter").text(i);
    });

    $('input[type="radio"]').click(function(){
        if($(this).is(':checked')){
            $('#token-input-phone_numbers').prop("disabled",true).fadeTo("slow",0.3)
        }
    })


    $('#token-input-phone_numbers').keyup(function(){
        var length = $(this).val().length;
        if(length > 1){
            $('input[type="radio"]').each(function(){
                $(this).prop("disabled", true);
                $(this).parent().fadeTo("slow",0.3)
            })
        }
        if(length == 0){
            $('input[type="radio"]').each(function(){
                $(this).prop("disabled", false);
                $(this).parent().fadeTo("slow",1)
            })
        }
    })
})


