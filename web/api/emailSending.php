<?php
         
        $to =  $_POST["email"];
        $from = "thoughtnav@gmail.com";
        $name = $_POST["name"];
        $subject = $_POST["subject"];
        $message = $_POST["message"];
        

// Always set content-type when sending HTML email
$headers = "MIME-Version: 1.0" . "\r\n";
$headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";

// More headers
$headers .= 'From: <thoughtnav@gmail.com>' . "\r\n";

mail($to,$subject,$message,$headers);


  $resultarray = array('message' => $message, 'email' =>$to, 'from' =>$from,'name'=>$name);
  
  $resultarray = array('error_code' => '1','message' =>'Data' , 'result' => $resultarray);
        echo json_encode($resultarray);
        exit();
?>