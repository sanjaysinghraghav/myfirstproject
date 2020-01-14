https://drive.google.com/file/d/0Byr6LCje9RPpWlFlMjdQZkJhMzg/view
(https://drive.google.com/file/d/0Byr6LCje9RPpWlFlMjdQZkJhMzg/view)

-->signup and registration 
C Tech हिन्दी
(https://github.com/ctechhindi/CodeIgniter-3-Login-and-Registration-System-using-MySQL-with-Bootstrap-4)


login and registration...........

Create database table 
CREATE TABLE IF NOT EXISTS `membership` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;


....................Setup base_url
application\config\config.php
$config['base_url']    = 'http://localhost/CODEIGNATER/';

setup routes
application\config\routes.php
$route['default_controller'] = "login_register";
........................
Create Controller
application\controllers\login_register.php....
...
<?php
class Login_register extends CI_Controller{
 function __construct()
  {
   parent::__construct();
    $this->load->helper(array('form', 'url'));
  }
 function index($msg = NULL)
 {
  $data['msg'] = $msg;
  $data['main_content'] = 'login_form';
  $this->load->view('includes/template', $data); 
   
   
 } 
 function validate_credentials()
 {  
  $this->load->model('membership_model');
  $query = $this->membership_model->validate();
   
  if($query) // if the user's credentials validated...
  {
   $data = array(
    'username' => $this->input->post('username'),
    'is_logged_in' => true
   );
   $this->session->set_userdata($data);
   redirect('Login_register/logged_in_area');
  }
  else // incorrect username or password
  {
   $msg = '<p class=error>Invalid username and/or password.</p>';
            $this->index($msg);
  }
 } 
  
 function signup()
 {
  $data['main_content'] = 'signup_form';
  $this->load->view('includes/template', $data);
 }
 function logged_in_area()
 {
  $data['main_content'] = 'logged_in_area';
  $this->load->view('includes/template', $data);
 }
  
 function create_member()
 {
  $this->load->library('form_validation');
   
  // field name, error message, validation rules
  $this->form_validation->set_rules('first_name', 'Name', 'trim|required');
  $this->form_validation->set_rules('last_name', 'Last Name', 'trim|required');
  $this->form_validation->set_rules('email_address', 'Email Address', 'trim|required|valid_email');
  $this->form_validation->set_rules('username', 'Username', 'trim|required|min_length[4]');
  $this->form_validation->set_rules('password', 'Password', 'trim|required|min_length[4]|max_length[32]');
  $this->form_validation->set_rules('password2', 'Password Confirmation', 'trim|required|matches[password]');
   
   
  if($this->form_validation->run() == FALSE)
  {
   $this->load->view('signup_form');
  }
   
  else
  {   
   $this->load->model('membership_model');
    
   if($query = $this->membership_model->create_member())
   {
    $data['main_content'] = 'signup_successful';
    $this->load->view('includes/template', $data);
   }
   else
   {
    $this->load->view('signup_form');   
   }
  }
   
 }
  
 function logout()
 {
  $this->session->sess_destroy();
  $this->index();
 }
 
}
/////////...
Create Modal
application\models\membership_model.php
......
<?php
class Membership_model extends CI_Model {
 function validate()
 {
  $this->db->where('username', $this->input->post('username'));
  $this->db->where('password', md5($this->input->post('password')));
  $query = $this->db->get('membership');
   
  if($query->num_rows == 1)
  {
   return true;
  }
   
 }
 function create_member()
 {
  $new_member_insert_data = array(
   'first_name' => $this->input->post('first_name'),
   'last_name' => $this->input->post('last_name'),
   'email_address' => $this->input->post('email_address'),   
   'username' => $this->input->post('username'),
   'password' => md5($this->input->post('password'))      
  );
   
  $insert = $this->db->insert('membership', $new_member_insert_data);
  return $insert;
 }
}


/////////
Create View
application\views\includes\header.php

<html lang="en">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
 <title>Sign Up!</title>
 <link rel="stylesheet" href="<?php echo base_url();?>/css/style.css" type="text/css" media="screen" />
</head>
<body>

/////////
Create View
application\views\includes\tutorial_info.php
?
<div>created by <a href="http://tutorial101.blogspot.com/">http://tutorial101.blogspot.com/</a></div>

Create View
application\views\includes\template.php


<?php $this->load->view('includes/header'); ?>
<?php $this->load->view($main_content); ?>
<?php $this->load->view('includes/footer'); ?>

Create View
application\views\includes\footer.php


<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js" type="text/javascript" charset="utf-8"></script> 
 <script type="text/javascript" charset="utf-8">
  $('input').click(function(){
   $(this).select(); 
  });
 </script>
</body>
</html>

Create View
application\views\signup_form.php


<?php $this->load->view('includes/header'); ?>
<h1>Create an Account!</h1>
<fieldset>
<legend>Personal Information</legend>
<?php
echo form_open('Login_register/create_member');
echo form_input('first_name', set_value('first_name', 'First Name'));
echo form_input('last_name', set_value('last_name', 'Last Name'));
echo form_input('email_address', set_value('email_address', 'Email Address'));
?>
</fieldset>
 
<fieldset>
<legend>Login Info</legend>
<?php
echo form_input('username', set_value('username', 'Username'));
echo form_input('password', set_value('password', 'Password'));
echo form_input('password2', 'Password Confirm');
 
echo form_submit('submit', 'Create Acccount');
?>
<?php echo validation_errors('<p class="error">'); ?>
</fieldset>
<?php $this->load->view('includes/tutorial_info'); ?>
<?php $this->load->view('includes/footer'); ?>


Create View
application\views\signup_successful.php

<h1>Congrats!</h1>
<p>Your account has not been created. <?php echo anchor('Login_register', 'Login Now');?></p>


Create View
application\views\logged_in_area.php


<html lang="en">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
 <title>Login Regsiter codeigniter</title>
</head>
<body>
 <h2>Welcome Back, <?php echo $this->session->userdata('username'); ?>!</h2>
     <p>This section represents the area that only logged in members can access.</p>
 <h4><?php echo anchor('Login_register/logout', 'Logout'); ?></h4>
</body>
</html> 


Create folder name css root directory
css\style.cs

body {
 background: #b6b6b6;
 margin: 0;
 padding: 0;
 font-family: arial;
}
 
#login_form {
 width: 300px;
 margin: 10px auto 0;
 padding: 1em;
 border-radius: 5px; -webkit-border-radius: 5px; -moz-border-radius: 5px;
 background-color: #EBF8D6;
 border: 1px solid #A6DD88;
 color: #539B2D;
}
h1,h2,h3,h4,h5 {
 margin-top: 0;
 font-family:Arial, Lucida Grande, Verdana, Sans-serif;font-size:22px;color:#000;
 text-align: center;
}
input[type=text], input[type=password] {
 display: block;
 margin: 0 0 1em 0;
 width: 280px;
 border: 5px;
 -moz-border-radius: 1px;
 -webkit-border-radius: 1px;
 padding: 1em;
 border: 1px solid #CCCCCC;
}
input[type=submit] {
 border:1px outset #ccc;padding:5px 2px 4px;color:#fff;min-width: 100px;text-align: center;cursor:pointer;background:#729e01;background:-webkit-gradient(linear, left top, left bottom,from(#a3d030),to(#729e01));background:-moz-linear-gradient(top,#a3d030,#729e01);background:-o-linear-gradient(top,#a3d030,#729e01);background:linear-gradient(top,#a3d030,#729e01);-moz-border-radius:7px; -webkit-border-radius:7px;
}
input[type=submit]:hover {
 background: #6B8426;
 cursor: pointer;
}
/* Validation error messages */
.error {
 background-color: #FFECE6;
 border: 1px solid #FF936F;
 color: #842100;
 background-image: url(../img/delete00.png);
  
 background-repeat: no-repeat;
 background-position: 10px center;
 height: 20px;
 text-transform: uppercase;
 font-size: 11px;
 line-height: 22px;
 margin-bottom: 20px;
 padding-top: 10px;
 padding-right: 10px;
 padding-bottom: 10px;
 padding-left: 50px;
}
 
fieldset {
 width: 300px;
 margin: auto;
 margin-bottom: 2em;
 display: block;
}


create folder name img root directory View http://localhost/CODEIGNATER/Login_register/






