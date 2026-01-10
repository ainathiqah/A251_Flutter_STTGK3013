<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

$user_id = $_GET['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode(["success" => false, "message" => "User ID required"]);
    exit();
}

// Get ALL adoption requests for this user:
// 1. Where user is the REQUESTER (user_id in tbl_adoptions)
// 2. Where user is the PET OWNER (p.user_id in tbl_pets)
$sql = "SELECT 
    a.adoption_id,
    a.user_id as requester_id,
    a.pet_id,
    a.motivation,
    a.adoption_status,
    a.request_date,
    p.pet_name,
    p.pet_type,
    p.pet_age,
    p.pet_gender,
    
    -- Requester info (always the user who made the request)
    ur.name as requester_name,
    ur.email as requester_email,
    ur.phone as requester_phone,
    
    -- Pet owner info
    po.name as owner_name,
    po.user_id as owner_id,
    po.email as owner_email
    
FROM tbl_adoptions a
INNER JOIN tbl_pets p ON a.pet_id = p.pet_id
INNER JOIN tbl_users ur ON a.user_id = ur.user_id  -- User who made the request
INNER JOIN tbl_users po ON p.user_id = po.user_id  -- Pet owner
WHERE a.user_id = '$user_id'  -- User is the requester
   OR p.user_id = '$user_id'  -- User is the pet owner
ORDER BY a.request_date DESC";

$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $requests = [];
    while ($row = $result->fetch_assoc()) {
        $requests[] = $row;
    }
    
    echo json_encode([
        "success" => true, 
        "data" => $requests
    ]);
} else {
    echo json_encode([
        "success" => false, 
        "data" => [], 
        "message" => "No adoption records found"
    ]);
}

$conn->close();
?>