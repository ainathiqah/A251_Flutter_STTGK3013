<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

$adoption_id = $_POST['adoption_id'] ?? '';
$user_id = $_POST['user_id'] ?? ''; // This is the pet owner's ID

if (empty($adoption_id) || empty($user_id)) {
    echo json_encode(["success" => false, "message" => "Missing data"]);
    exit();
}

// Start transaction
$conn->begin_transaction();

try {
    // 1. Get the adoption request details and verify ownership
    $getSql = "SELECT a.pet_id, a.user_id AS requester_id 
               FROM tbl_adoptions a
               JOIN tbl_pets p ON a.pet_id = p.pet_id
               WHERE a.adoption_id = '$adoption_id' 
               AND p.user_id = '$user_id'";
    
    $result = $conn->query($getSql);
    
    if ($result->num_rows == 0) {
        throw new Exception("Adoption request not found or you don't own this pet");
    }
    
    $row = $result->fetch_assoc();
    $pet_id = $row['pet_id'];
    $requester_id = $row['requester_id'];
    
    // 2. Update the pet's adoption status and set adopter
    $updatePet = "UPDATE tbl_pets 
                  SET adoption_status = 'adopted'
                  WHERE pet_id = '$pet_id' AND user_id = '$user_id'";
    
    if (!$conn->query($updatePet)) {
        throw new Exception("Failed to update pet status");
    }
        
    $conn->commit();
    echo json_encode(["success" => true, "message" => "Adoption accepted successfully"]);
    
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}
?>