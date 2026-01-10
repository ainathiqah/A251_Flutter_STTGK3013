<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode([
        "success" => false, 
        "message" => "Invalid Request Method. Use POST"
    ]);
    exit();
}

// Check required fields
if (!isset($_POST['user_id']) || !isset($_POST['name']) || !isset($_POST['phone'])) {
    echo json_encode([
        "success" => false, 
        "message" => "Missing required fields: user_id, name, phone"
    ]);
    exit();
}

$user_id = $conn->real_escape_string($_POST['user_id']);
$name = $conn->real_escape_string($_POST['name']);
$phone = $conn->real_escape_string($_POST['phone']);
$email = isset($_POST['email']) ? $conn->real_escape_string($_POST['email']) : '';
$image = isset($_POST['image']) ? $_POST['image'] : '';

// Basic validation
if (empty($name) || empty($phone)) {
    echo json_encode([
        "success" => false, 
        "message" => "Name and phone are required"
    ]);
    exit();
}

// Check if user exists
$check_sql = "SELECT user_id FROM tbl_users WHERE user_id = '$user_id'";
$check_result = $conn->query($check_sql);
if ($check_result->num_rows == 0) {
    echo json_encode([
        "success" => false, 
        "message" => "User not found"
    ]);
    exit();
}

// Start building SQL
$sql = "UPDATE tbl_users SET 
        name = '$name', 
        phone = '$phone', 
        email = '$email'";

// Handle image if provided
$filename = null;
if (!empty($image)) {
    $decode_image = base64_decode($image);
    
    if ($decode_image === false) {
        echo json_encode([
            "success" => false, 
            "message" => "Invalid image format"
        ]);
        exit();
    }
    
    $filename = "profileImage" . $user_id . ".png";
    $path = "../assets/profileImage/" . $filename;
    
    // Ensure directory exists
    if (!is_dir("../assets/profileImage/")) {
        mkdir("../assets/profileImage/", 0777, true);
    }
    
    if (file_put_contents($path, $decode_image)) {
        $sql .= ", image = '$filename'";
    } else {
        echo json_encode([
            "success" => false, 
            "message" => "Failed to save image"
        ]);
        exit();
    }
}

$sql .= " WHERE user_id = '$user_id'";

if ($conn->query($sql) === TRUE) {
    // Get updated user data
    $select_sql = "SELECT user_id, name, email, phone, reg_date, image as image_profile FROM tbl_users WHERE user_id = '$user_id'";
    $result = $conn->query($select_sql);
    $userdata = $result->fetch_assoc();
    
    $response = [
        "success" => true,
        "status" => "success",
        "message" => "Profile updated successfully",
        "data" => $userdata
    ];
    
    // Add new image filename if uploaded
    if ($filename !== null) {
        $response['new_image'] = $filename;
    }
    
    echo json_encode($response);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Profile update failed: " . $conn->error
    ]);
}

$conn->close();
?>