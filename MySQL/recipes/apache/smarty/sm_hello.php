<?php
# sm_hello.php - simple Smarty script

require_once "Smarty.class.php";

$smarty = new Smarty ();
$smarty->assign ("name", "world");
$smarty->assign ("addr", $_SERVER["REMOTE_ADDR"]);
$smarty->display ("sm_hello.tmpl");
?>
