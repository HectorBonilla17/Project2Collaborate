<?php

// ftp server information
$ftp_server = "FtpIpAddress";
$ftp_username = "myusername";
$ftp_userpass = "mypassword";
$destination_file = "DirectoryPath";

// connect and login to FTP server
$ftp_conn = ftp_connect($ftp_server) or die("Could not connect to $ftp_server");
$login = ftp_login($ftp_conn, $ftp_username, $ftp_userpass);
 
// Getting uploaded file
$file = $_FILES["file"]; 
 
// Uploading in "uplaods" folder
//move_uploaded_file($file["tmp_name"], "uploads/" . $file["name"]);

// upload file
if (ftp_put($ftp_conn, destination_file, $file, FTP_ASCII))
  {
  	echo "Successfully uploaded $file.";
  }
else
  {
  	echo "Error uploading $file.";
  }


// close connection
ftp_close($ftp_conn);
 

//Don't know if needed
// Redirecting back
//header("Location: " . $_SERVER["HTTP_REFERER"]);