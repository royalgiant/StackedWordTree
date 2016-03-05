$(document).ready(function() {
	 $("input[type=file]").change(function (){
       var fileName = $(this).val();
       $("p.fileName").html(fileName);
     });
});