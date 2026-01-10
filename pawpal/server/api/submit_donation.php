<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
include 'dbconnect.php';

// Initialize response
$response = array('success' => false, 'message' => '');

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Check required fields
    if (!isset($_POST['user_id']) || !isset($_POST['pet_id']) || !isset($_POST['donation_type'])) {
        $response['message'] = 'Required fields missing: user_id, pet_id, donation_type';
        sendJsonResponse($response);
        exit();
    }
    
    // Sanitize inputs
    $userid = $conn->real_escape_string($_POST['user_id']);
    $petid = $conn->real_escape_string($_POST['pet_id']);
    $donationtype = $conn->real_escape_string($_POST['donation_type']);
    $amount = isset($_POST['amount']) ? $conn->real_escape_string($_POST['amount']) : '0';
    $description = isset($_POST['description']) ? $conn->real_escape_string($_POST['description']) : '';
    
    // Validate amount for Money type
    if ($donationtype == 'Money') {
        if (!is_numeric($amount) || floatval($amount) <= 0) {
            $response['message'] = 'Invalid amount for money donation';
            sendJsonResponse($response);
            exit();
        }
    }
    
    // SQL INSERT statement - corrected
    $sqlinsert = "INSERT INTO tbl_donation(user_id, pet_id, donation_type, amount, description, donation_date) 
                  VALUES('$userid', '$petid', '$donationtype', '$amount', '$description', NOW())";
    
    // Execute query
    if ($conn->query($sqlinsert) === TRUE) {
        $response['success'] = true;
        $response['message'] = 'Donation submitted successfully';
        $response['donation_id'] = $conn->insert_id;
    } else {
        $response['message'] = 'Database error: ' . $conn->error;
    }
} else {
    $response['message'] = 'Invalid request method. Use POST';
}

// Send JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

// Close connection
$conn->close();

// Send final response
sendJsonResponse($response);
?>