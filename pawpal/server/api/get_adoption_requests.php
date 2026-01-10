<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

$user_id = $_GET['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode(["success" => false, "message" => "User ID required"]);
    exit();
}

// Get adoption requests where this user is the requester OR the pet owner
// Let's first check what we have in the database
$debug_sql = "SELECT 
    a.adoption_id,
    a.user_id as requester_id,
    a.pet_id,
    a.motivation,
    a.adoption_status,
    a.request_date,
    p.pet_name,
    p.user_id as pet_owner_id,
    u.name as requester_name
FROM tbl_adoptions a
LEFT JOIN tbl_pets p ON a.pet_id = p.pet_id
LEFT JOIN tbl_users u ON a.user_id = u.user_id
ORDER BY a.request_date DESC";

$debug_result = $conn->query($debug_sql);
$all_requests = [];
while ($row = $debug_result->fetch_assoc()) {
    $all_requests[] = $row;
}

// Now get requests for pets owned by this user
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
    p.adoption_status as pet_adoption_status,
    u.name as requester_name,
    u.email as requester_email,
    u.phone as requester_phone,
    ou.name as owner_name  -- Pet owner name
FROM tbl_adoptions a
INNER JOIN tbl_pets p ON a.pet_id = p.pet_id
INNER JOIN tbl_users u ON a.user_id = u.user_id
INNER JOIN tbl_users ou ON p.user_id = ou.user_id  -- Join for pet owner
WHERE p.user_id = '$user_id'  -- This user owns the pet
ORDER BY a.request_date DESC";

$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $requests = [];
    while ($row = $result->fetch_assoc()) {
        $requests[] = $row;
    }
    
    // For debugging
    error_log("DEBUG - User $user_id (pet owner) has " . count($requests) . " adoption requests");
    error_log("DEBUG - All adoption requests in DB: " . json_encode($all_requests));
    
    echo json_encode([
        "success" => true, 
        "data" => $requests,
        "debug" => [
            "total_requests_in_db" => count($all_requests),
            "user_requests" => count($requests),
            "user_id" => $user_id
        ]
    ]);
} else {
    error_log("DEBUG - No adoption requests found for pet owner: $user_id");
    echo json_encode([
        "success" => false, 
        "data" => [], 
        "message" => "No adoption requests found for your pets",
        "debug" => [
            "total_requests_in_db" => count($all_requests),
            "all_requests" => $all_requests,
            "user_id" => $user_id
        ]
    ]);
}
?>