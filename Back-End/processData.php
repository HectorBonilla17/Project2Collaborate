<?php

$time = microtime(true);
$fileIn = "input/" . $time . ".txt";
$fileOut = "output/" . $time . ".txt";

    $inputData = $_POST['input1'].'&&&'.$_POST['input2'].'&&&'.$_POST['input3'].'&&&'.$_POST['input4'].'&&&'.$_POST['input5'].'&&&'.$_POST['input6'].'&&&'.$_POST['input7'].'&&&'.$_POST['input8'].'&&&'.$_POST['input9'].'&&&'.$_POST['input10'].'&&&'.$_POST['input11'].'&&&'.$_POST['input12'].'&&&'.$_POST['input13'].'&&&'.$_POST['input14'].'&&&'.$_POST['input15'].'&&&'.$_POST['input16'].'&&&'.$_POST['input17'].'&&&'.$_POST['input18'].'&&&'.$_POST['input19'].'&&&'.$_POST['input20']."\n";
    $returnedData = file_put_contents($fileIn, $inputData, FILE_APPEND | LOCK_EX);
    if($returnedData === false) {
        die('There was an error writing to this file.');
    }
    else {
        sleep(3);
        $output = file_get_contents($fileOut);
        echo "$output";
    }

?>
