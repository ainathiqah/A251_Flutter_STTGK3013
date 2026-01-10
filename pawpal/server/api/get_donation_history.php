<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $user_id = $_GET['user_id'] ?? '';
    $search = $_GET['search'] ?? '';

    if (empty($user_id)) {
        sendJsonResponse([
            "success" => false,
            "message" => "User ID is required"
        ]);
        exit();
    }

    // Get user's donation history with pet info
    $sql = "
        SELECT 
            d.donation_id,
            d.user_id,
            d.pet_id,
            d.donation_type,
            d.amount,
            d.description,
            d.donation_date,
            p.pet_name,
            p.pet_type,
            u.name AS user_name
        FROM tbl_donation d
        LEFT JOIN tbl_pets p ON d.pet_id = p.pet_id
        LEFT JOIN tbl_users u ON d.user_id = u.user_id
        WHERE d.user_id = '$user_id'
    ";

    // Search by donation type, description, or pet name
    if (!empty($search)) {
        $search = $conn->real_escape_string($search);
        $sql .= " AND (
            d.donation_type LIKE '%$search%' 
            OR d.description LIKE '%$search%' 
            OR p.pet_name LIKE '%$search%'
            OR d.amount LIKE '%$search%'
        )";
    }

    // Order by latest donation first
    $sql .= " ORDER BY d.donation_date DESC";

    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $data = [];
        while ($row = $result->fetch_assoc()) {
            // Format amount to 2 decimal places
            $row['amount'] = number_format($row['amount'], 2, '.', '');
            
            // Format donation_date if needed
            if (!empty($row['donation_date'])) {
                $date = new DateTime($row['donation_date']);
                $row['formatted_date'] = $date->format('d M Y, h:i A');
                $row['simple_date'] = $date->format('d M Y');
            }
            
            $data[] = $row;
        }
        sendJsonResponse([
            "success" => true,
            "data" => $data
        ]);
    } else {
        sendJsonResponse([
            "success" => false,
            "data" => [],
            "message" => "No donation history found"
        ]);
    }

} else {
    sendJsonResponse([
        "success" => false,
        "message" => "Invalid request"
    ]);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>