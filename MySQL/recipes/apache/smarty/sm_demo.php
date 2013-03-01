<?php
# sm_demo.php - Smarty demonstration script

require_once "Smarty.class.php";

$smarty = new Smarty ();

$smarty->assign ("character_name", "Peregrine Pickle");
$smarty->assign ("character_role", "a young country gentleman");
$smarty->assign ("str_to_encode", "encoded text: (<>&'\" =;)");
$smarty->assign ("id", 47846);
$colors = array ("red","orange","yellow","green","blue","indigo","violet");
$smarty->assign ("colors", $colors);

$smarty->display ("sm_demo.tmpl");
?>
