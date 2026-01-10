<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if (!isset($_POST['user_id']) || !isset($_POST['pet_id'])) {
    $response = array('success' => false, 'data' => null);
    sendJsonResponse($response);
    exit();
}

$userid = $conn->real_escape_string($_POST['user_id']);
$petid = $conn->real_escape_string($_POST['pet_id']);
$motivation = $conn->real_escape_string($_POST['motivation']);

// Add default adoption_status as 'pending'
$sqlinsert = "INSERT INTO tbl_adoptions(user_id, pet_id, motivation, adoption_status, request_date)
                VALUES('$userid','$petid','$motivation','pending',NOW())";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('success' => true, 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('success' => false, 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>