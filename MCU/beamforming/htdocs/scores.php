<html>
<head>
   <title>STEM Games Beamforming Scores</title>
   <style>
         @font-face {
        font-family: montserrat;
        src: url(Montserrat-Regular.ttf);
      }

      div {
        font-family: montserrat;
      }
   </style>
</head>
<body>
<div style="font-size:24pt"><img src="arena_logo.png" alt="E arena" style="height:100px" align="middle">Beamforming scores</div></br>
<div>
<?php

$row = 1;
if (($handle = fopen("scores.csv", "r")) !== FALSE) {
   
    echo '<table cellspacing=10em>';
   
    while (($data = fgetcsv($handle, 1000, ";")) !== FALSE) {
        $num = count($data);
        if ($row == 1) {
            echo '<thead><tr>';
        }else{
            echo '<tr>';
        }
       
        for ($c=0; $c < $num; $c++) {
            if(empty($data[$c])) {
               $value = "0";
            }else{
               $value = $data[$c];
            }
            
            if ($row == 1) {
                echo '<th';
            } else {
               echo '<td';
            }
                   
            if ($c == 0 || $c == 6) {
               echo ' style="font-weight:bold"';
            }
            
            echo '>';
            echo (string) $value;
            
            if ($row == 1) {
               echo '</th>';
            } else {
               echo '</td>';
            }
        }
       
        if ($row == 1) {
            echo '</tr></thead><tbody>';
        }else{
            echo '</tr>';
        }
        $row++;
    }
   
    echo '</tbody></table>';
    fclose($handle);
}
?>
</div>
</body>
</html>