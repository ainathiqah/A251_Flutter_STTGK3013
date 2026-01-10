<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    // Get all pets with owner info AND adoption status
    $sql = "
        SELECT 
            p.pet_id,
            p.user_id,
            p.pet_name,
            p.pet_type,
            p.pet_age,
            p.pet_gender,
            p.pet_health,
            p.category,
            p.description,
            p.image_paths,
            p.lat,
            p.lng,
            p.created_at,
            u.name,         
            u.email,        
            u.phone,
            -- Get the latest adoption status for this pet
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM tbl_adoptions 
                    WHERE pet_id = p.pet_id 
                    AND adoption_status = 'approved'
                ) THEN 'adopted'
                WHEN EXISTS (
                    SELECT 1 FROM tbl_adoptions 
                    WHERE pet_id = p.pet_id 
                    AND adoption_status = 'pending'
                ) THEN 'pending'
                ELSE 'available'
            END AS adoption_status
        FROM tbl_pets p
        LEFT JOIN tbl_users u ON p.user_id = u.user_id
        WHERE 1
    ";

    // Search by pet name, category, description
    if (!empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sql .= " AND (
            p.pet_name LIKE '%$search%' 
            OR p.category LIKE '%$search%' 
            OR p.description LIKE '%$search%'
            OR u.name LIKE '%$search%'     // Also search by owner name
        )";
    }

    // Filter by pet type (Cat, Dog, Other)
    if (!empty($_GET['type']) && $_GET['type'] != 'All') {
        $type = $conn->real_escape_string($_GET['type']);
        if ($type == 'Other') {
            $sql .= " AND p.pet_type NOT IN ('Cat','Dog')";
        } else {
            $sql .= " AND p.pet_type = '$type'";
        }
    }

    // Order latest first
    $sql .= " ORDER BY p.pet_id DESC";

    $result = $conn->query($sql);

    if ($result) {
        if ($result->num_rows > 0) {
            $data = [];
            while ($row = $result->fetch_assoc()) {
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
                "message" => "No pets found"
            ]);
        }
    } else {
        // SQL error occurred
        sendJsonResponse([
            "success" => false,
            "message" => "SQL Error: " . $conn->error
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