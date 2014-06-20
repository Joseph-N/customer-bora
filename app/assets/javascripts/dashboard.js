$("#message").keyup(function () {
    var i = $("#message").val().length;
    $("#counter").text(i);
});

