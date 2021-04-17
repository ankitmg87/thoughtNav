<?php

require('vendor/autoload.php');//this file is used to genrate file
error_reporting(E_ALL);
ini_set('display_errors', 1);
date_default_timezone_set('Asia/Kolkata');
header('Content-Type: application/json');
header("Pragma: no-cache");
header("Cache-Control: no-cache");
header("Expires: 0");



    $pdf_data= $_POST['pdf_data'];

    //convert data for generating pdf
    $data = json_decode($pdf_data,'true');


        $space ='&nbsp;&nbsp;&nbsp;&nbsp;';
        if(empty($pdf_data)){
             $resultarray = array('error_code' => '1', 'message' => 'Not Success ');
            echo json_encode($resultarray);
            exit();
        
        }else{
               //desgin pdf

			     $studyname = $data['studyName'];
			     $html ='<h3 style="text-align: center">'.$studyname.'</h3>';
                 $html.='<hr>';

                 $internalStudyLabel = $data['internalStudyLabel'];
                 $studyStatus =$data['studyStatus'];
                 $beginDate = $data['beginDate'];
                 $endDate = $data['endDate'];
                 $activeParticipants= $data['activeParticipants'];
                 $totalParticipants= $data['totalParticipants'];
                 $totalResponses= $data['totalResponses'];
                 $totalComments= $data['totalComments'];
                 
                 $html.='<style>
                table, th, td #t{
                  text-align: center;
                
                  padding: 15px;
                }"></style><table class="table t">';
             
                    $html.='<tr><th>Internal Study Label</th><td>'.$internalStudyLabel.'</td></tr>';
                   $html.='<tr><th>Study Status</th><td>'.$studyStatus.'</td></tr>';
                   $html.='<tr><th>Begin Date</th><td>'.$beginDate.'</td></tr>';
                   $html.='<tr><th>End Date</th><td>'.$endDate.'</td></tr>';
                   $html.='<tr><th>Active Participants</th><td>'.$activeParticipants.'</td></tr>';
                   $html.='<tr><th>Total Responses</th><td>'.$totalResponses.'</td></tr>';
                   $html.='<tr><th>Total Comments</th><td>'.$totalComments.'</td></tr>';


                	$html.='</table>';
                	
                 $reportTopics= $data['reportTopics'];
                 
                $pdfdataarr = array();
                if (!empty($reportTopics)){
			           foreach ($reportTopics as $key => $value){
               

                           $html.='<h4 style="text-align: left">Topic '.$value['topicNumber'] .'  . &nbsp;&nbsp; '.$value['topicName'] .'</h4>';

                         if (!empty($value['reportQuestions'])){
                           foreach ($value['reportQuestions'] as $key => $value2){
                              
                                $html.='<h4 style="text-left: center">Q '.$value2['questionNumber'] .'  . &nbsp;&nbsp; '.$value2['questionTitle'] .'</h4>';

                                $html.=$value2['questionStatement'];
                                     if (!empty($value2['reportResponses'])){
                                        foreach ($value2['reportResponses'] as $key => $value3){
                                            
                
                                             $html.='<div style="border-radius: 25px;
                                              border: 2px solid #73AD21;
                                              padding-left: 10px; 
                                              padding-right: 10px; 

                                              width: 600px;
                                              height: 30px";>';
                                             $html.='<table class="table">';
                                             
                                            $html.='<tr><td><img src='.$value3['participantAvatarURL'] .'/></td><td><b>'.$value3['participantDisplayName'].'</td></tr>';
                                            $html.='<tr><td>'.$space.'</td> <td> '.$value3['dateAndTime'] .'</td></tr>';
                	$html.='</table>';


                                            $html.='<p>'.$value3['responseStatement'] .'</p>';

                                        if($value3['mediaType'] =='image'){
                                              $html.='<img  src='.$value3['mediaURL'] .' width="120" height="120" />' ;
                                           }else if($value3['mediaType'] =='video'){
                                                $html.='<img  src="http://bluechipdigitech.com/pdftesting/api/play_button.png" width="120" height="120" />' ;
                                           }
                                        

                                            $html.='</div>';
                                            $html.='<br><br>';
                                    
                                        }
                                     }
                               
                           }
                }


			               	
			           }}
			           
			           
		
                $time = 'upload/'.time().'.pdf';
                $path = "http://bluechipdigitech.com/test_thoughtnav/web/api/" . $time;//this path is hard coded need to be updated depend on server pdf folder path
                
                //this function is to generate pdf
                $mpdf=new \Mpdf\Mpdf();
                $mpdf->WriteHTML($html);
                $file=$time;
                $mpdf->output($file,'f');

				$resultarray = array('error_code' => '1', 'message' => $path);
                echo json_encode($resultarray);
                exit();
        }
        

        
