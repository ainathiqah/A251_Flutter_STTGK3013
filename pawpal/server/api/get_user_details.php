<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Database connection
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if (!isset($_GET['userid'])) {
        $response = [
            'status' => 'failed', 
            'message' => 'Missing userid parameter'
        ];
        sendJsonResponse($response);
        exit();
    }
    
    $userid = $conn->real_escape_string($_GET['userid']);
    
    // Get user details including profile image
    // Using 'image' column but returning as 'image_profile' for consistency
    $sql = "SELECT 
                user_id, 
                name, 
                email, 
                phone, 
                reg_date, 
                image as image_profile,
            FROM tbl_users 
            WHERE user_id = '$userid'";
    
    $result = $conn->query($sql);
    
    if ($result && $result->num_rows > 0) {
        $userdata = $result->fetch_assoc();
        
        // Ensure image_profile is not null
        if ($userdata['image_profile'] === null) {
            $userdata['image_profile'] = "";
        }
        
        $response = [
            'status' => 'success', 
            'message' => 'User details retrieved successfully', 
            'data' => array($userdata)
        ];
        sendJsonResponse($response);
    } else {
        $response = [
            'status' => 'failed', 
            'message' => 'User not found',
            'data' => null
        ];
        sendJsonResponse($response);
    }
} else {
    $response = [
        'status' => 'failed', 
        'message' => 'Method Not Allowed. Use GET method'
    ];
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    echo json_encode($sentArray);
}

$conn->close();
?>