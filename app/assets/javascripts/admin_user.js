$(document).ready(function(){
	$.validator.addMethod('email_tip', function(value, element) {
	return this.optional(element) || /^[a-zA-Z0-9_\.\-]+(\.[_a-z0-9]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/.test(value);
	}, "Email format is wrong.");
	// #admin user login js validations
	$('#new_admin_user').validate({
		onkeyup: function(element) {$(element).valid()},
	    rules: {
			'admin_user[login]': {required: true,minlength: 2,maxlength: 60,remote: "/validate_admin_email"},
			'admin_user[password]': {required:  true,minlength: 8 ,remote: {
          url: "/validate_admin_password",
          type: "get",
          data: {
            email: function() {
              return $("#admin_user_login").val();
            }
          }
        }
    	},
     	},
	    messages: {
			'admin_user[login]': {required: 'Please enter your username or email.',remote: "Please check your username or email.",minlength: 'Username OR Email must be at least 2 characters!'},
			'admin_user[password]': {required: 'Please enter your password.',remote: "Password is wrong.",minlength: 'Password is too short.!'},
	    },
	    submitHandler: function(form) {
	    	form.submit();
	    }
	});

	// #admin forgot password js validations
	$('#admin-user-form-id').validate({
		onkeyup: function(element) {$(element).valid()},
	    rules: {
			'admin_user[email]': {required: true,email_tip: true,minlength: 2,maxlength: 60,remote: "/forgot_password_email"},
     	},
	    messages: {
			'admin_user[email]': {required: 'Please enter your email.',minlength: 'Email must be at least 2 characters!',remote: "Email address doesn't exist."},
	    },
	    submitHandler: function(form) {
	    	form.submit();
	    }
	});

	$("#change-admin-user-password").validate({
     onfocusout: function (element) {
       $(element).valid();
      },
      rules: {
        'static_content[password]': {required:  true,alphanumericpassword: true,minlength: 8,maxlength: 25},
        'static_content[password_confirmation]': {required:  true,minlength: 8,maxlength: 25,equalTo: "#static_content_password"},
      },
      messages: {
        'static_content[password]': {required: 'Please enter password.',minlength: 'Password must be at least 8 characters.',maxlength: 'Password must be at least 8 characters.'},
        'static_content[password_confirmation]': {required: 'Please enter password confirmation.',minlength: 'Password must be at between 8 characters.',maxlength: 'Password must be at least 8 characters.',equalTo: "Password and password confirmation doesn't match"}
      },
     submitHandler: function(form) {
      form.submit();
     }
    });

});
