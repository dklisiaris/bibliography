var FormsValidation=function(){return{init:function(){$("#form-validation").validate({errorClass:"help-block animation-pullUp",errorElement:"div",errorPlacement:function(e,r){r.parents(".form-group > div").append(e)},highlight:function(e){$(e).closest(".form-group").removeClass("has-success has-error").addClass("has-error"),$(e).closest(".help-block").remove()},success:function(e){e.closest(".form-group").removeClass("has-success has-error"),e.closest(".help-block").remove()},rules:{"val-username":{required:!0,minlength:3},"val-email":{required:!0,email:!0},"val-password":{required:!0,minlength:5},"val-confirm-password":{required:!0,equalTo:"#val-password"},"val-suggestions":{required:!0,minlength:5},"val-skill":{required:!0},"val-website":{required:!0,url:!0},"val-digits":{required:!0,digits:!0},"val-number":{required:!0,number:!0},"val-range":{required:!0,range:[1,5]},"val-terms":{required:!0}},messages:{"val-username":{required:"Please enter a username",minlength:"Your username must consist of at least 3 characters"},"val-email":"Please enter a valid email address","val-password":{required:"Please provide a password",minlength:"Your password must be at least 5 characters long"},"val-confirm-password":{required:"Please provide a password",minlength:"Your password must be at least 5 characters long",equalTo:"Please enter the same password as above"},"val-suggestions":"What can we do to become better?","val-skill":"Please select a skill!","val-website":"Please enter your website!","val-digits":"Please enter only digits!","val-number":"Please enter a number!","val-range":"Please enter a number between 1 and 5!","val-terms":"You must agree to the service terms!"}})}}}();