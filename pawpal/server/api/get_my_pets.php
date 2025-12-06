<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    if (!isset($_GET['user_id'])) {
        $response = array('success' => false, 'message' => 'Missing user id');
        sendJsonResponse($response);
        exit();
    }

    $user_id = $_GET['user_id'];

    $sql = "
     SELECT 
        p.pet_id,
        p.user_id,
        p.pet_name,
        p.pet_type,
        p.category,
        p.description,
        p.image_paths,
        p.lat,
        p.lng,
        p.created_at,
        u.name,
        u.email,
        u.phone
    FROM tbl_pets p
    JOIN tbl_users u ON p.user_id = u.user_id
    WHERE p.user_id = '$user_id'
    ";

    // Search logic
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sql .= " AND (
            p.pet_name LIKE '%$search%' 
            OR p.category LIKE '%$search%'
            OR p.description LIKE '%$search%'
        )";
    }

    // Order
    $sql .= " ORDER BY p.pet_id DESC";

    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        $response = array("success"=> true,"data"=> $petdata);
        sendJsonResponse($response);
    } else {
        $response = array("success"=> false,"message"=> "No submission yet", "data"=>[]);
        sendJsonResponse($response);
        exit();
    }

} else {
    $response = array("success"=> false,"message"=> "Invalid request", "data"=>[]);
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
