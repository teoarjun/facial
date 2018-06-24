$(document).on('ready pjax:success', function() {
  $('.nav li.icon.impersonate_user_member_link').hide();
  if ($('.page-header h1').html() == ("Static content management"))
  {
    $('.well').hide();
  }
  if ($('.page-header h1').html() == ("User"))
  {
   $('.breadcrumb li:nth-child(2)').html("Users");
   $('.page-header h1 ').html("Users");   
  }
 
  if($('.icon-plus').next().text() != "Add User" )
  {
    $('.icon-plus').next().text("Add Admin User");
  }

  if($('.page-header h1').text() == "Admin user")
  {
    $('.page-header h1').text("Admin Users");
  }
  if(  $('.breadcrumb li.active').text() == "Admin user /")
  {
    $('.breadcrumb li.active').text("Admin Users");
  }
  if(  $('.breadcrumb li.active').text() == "Static content management /")
  {
    $('.breadcrumb li.active').text("Static Content Management");

  }

  // if(  $('.breadcrumb li.false > a.pjax').text() == "Dashboard / Admin user /")
  // {
  //   $('.breadcrumb li.false > a.pjax').text("Dashboard / Admin User /");

  // }
  jQuery.extend(jQuery.validator.messages, {
       accept: "Please enter jpg/png/jpeg/gif extension only.",
      });


  $.validator.addMethod('lettersonly', function(value, element) {
  return this.optional(element) || /^[A-Za-z0-9 _.-]+$/.test(value);
  }, 'Only letters,spaces and numbers are allowed.');
  $.validator.addMethod('email_tip', function(value, element) {
  return this.optional(element) || /^[a-zA-Z0-9_\.\-]+(\.[_a-z0-9]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/.test(value);
  }, "Please enter valid email.");
  $.validator.addMethod('alphanumericpassword', function(value, element) {
  return this.optional(element) || /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{8,}$/i.test(value);
  },"Password should be minimum of 8 characters having the special character and number.");

  $('.help-block').hide();
    $('#new_user').validate({
      onfocusout: function (element) {
       $(element).valid();
      },
      rules: {
        'user[name]': {required: true,lettersonly: true,minlength: 2,maxlength: 30},
        'user[email]': {required: true,email : true,email_tip: true,minlength: 8,maxlength: 60,remote: "/check_user_email"},
        'user[password]': {required:  true,alphanumericpassword: true,minlength: 8,maxlength: 30},
        'user[password_confirmation]': {required:  true,minlength: 8,maxlength: 30,equalTo: "#user_password"},
        'user[image]': {required: true,accept: "jpg,png,jpeg,gif"},
        "user[address]": {required: true},
        "user[dob]": {required: true},
        "user[bio]": {required: true,minlength: 20}
      },
      messages: {
        'user[name]': {required: 'Please enter name.',minlength: 'Name must be at least 2 characters.'},
        'user[email]': {required: 'Please enter email.',email: 'Please enter valid email.',minlength: 'Email must be at least 8 characters.',remote: "Email already registered."},
        'user[image]': {required: 'Please choose image.',accept: 'Only jpeg, jpg are allowed.'},
        'user[password]': {required: 'Please enter password.',minlength: 'Password must be at least 8 characters.',maxlength: 'Password must be at least 8 characters.'},
        'user[password_confirmation]': {required: 'Please enter password confirmation.',minlength: 'Password must be at between 8 characters.',maxlength: 'Password must be at least 8 characters.',equalTo: "Password and password confirmation doesn't match."},
        "user[dob]": {required: 'Please enter DOB.'},
        "user[bio]": {required: 'Please enter BioData.',minlength: "BioData should be minimum 20 characters."},
        "user[address]": {required: 'Please enter address.'},
      },
     submitHandler: function(form) {
      form.submit();
     }
    });

    $('#new_admin_user,#edit_admin_user').validate({
     onfocusout: function (element) {
       $(element).valid();
      },
      rules: {
        'admin_user[name]': {required: true,lettersonly: true,minlength: 2,maxlength: 30,remote: {
          url: "/check_admin_user_name",
          type: "get",
          data: {
            id: function() {
              return window.location.href.split("/")[5];
            }
          }
        }
      },
        'admin_user[email]': {required: true,email : true,email_tip: true,minlength: 8,maxlength: 60,remote: {
          url: "/check_admin_user",
          type: "get",
          data: {
            id: function() {
              return window.location.href.split("/")[5];
            }
          }
        }
      },
        'admin_user[password]': {required:  true,alphanumericpassword: true,minlength: 8,maxlength: 25},
        'admin_user[password_confirmation]': {required:  true,minlength: 8,maxlength: 25,equalTo: "#admin_user_password"},
        'admin_user[image]': {required: false,accept: "jpg,png,jpeg,gif"},
      },
      messages: {
        'admin_user[name]': {required: 'Please enter name.',minlength: 'Name must be at least 2 characters.',remote: "Username should be unique."},
        'admin_user[email]': {required: 'Please enter email.',email: 'Please enter valid email.',minlength: 'Email must be at least 8 characters.',remote: "Email already registered."},
        'admin_user[image]': 'Only jpeg, jpg are allowed.',
        'admin_user[password]': {required: 'Please enter password.',minlength: 'Password must be at least 8 characters.',maxlength: 'Password must be at least 8 characters.'},
        'admin_user[password_confirmation]': {required: 'Please enter password confirmation.',minlength: 'Password must be at between 8 characters.',maxlength: 'Password must be at least 8 characters.',equalTo: "Password and password confirmation doesn't match"}
      },
     submitHandler: function(form) {
      form.submit();
     }
    });
    
 // // #static content js
  $('#edit_static_content_management').validate({
    onfocusout: function (element) {
     $(element).valid();
    },
    rules: {
      "static_content_management[content]": {required: true},
    },
    messages: {
      "static_content_management[content]": {required: 'Please enter content.'},
    },
   submitHandler: function(form) {
    form.submit();
   }
  });
});

