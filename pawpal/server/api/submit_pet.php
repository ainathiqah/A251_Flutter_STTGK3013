<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}
$user_id = $_POST['user_id'];
$pet_name = $_POST['pet_name'];
$pet_type = $_POST['pet_type'];
$category = $_POST['category'];
$description = $_POST['description'];
$lat = $_POST['lat'];
$lng = $_POST['lng'];
$image1 = base64_decode($_POST["image1"]);
$image2 = base64_decode($_POST["image2"]);
$image3 = base64_decode($_POST["image3"]);

$image_paths = "";

//Insert new pet submission
$sqlinsert = "INSERT INTO tbl_pets 
(user_id, pet_name, pet_type, category, description, image_paths, lat, lng) 
VALUES 
('$user_id', '$pet_name', '$pet_type', '$category', '$description', '', '$lat', '$lng')";

try {
    if ($conn->query($sqlinsert) === TRUE) {
        $last_id = $conn->insert_id;

        if (!empty($image1)) {
            
            $path = "../assets/petImage/pet_".$last_id."_1.png";
            file_put_contents($path, $image1);
            $image_paths = "pet_".$last_id."_1.png";
            
        }
        if (!empty($image2)) {
            $path = "../assets/petImage/pet_".$last_id."_2.png";
            file_put_contents($path, $image2);
            $image_paths .= ", pet_".$last_id."_2.png";
        }
        if (!empty($image3)) {
            $path = "../assets/petImage/pet_".$last_id."_3.png";
            file_put_contents($path, $image3);
            $image_paths .= ", pet_".$last_id."_3.png";
        }
        
        $updatesql ="UPDATE tbl_pets SET image_paths = '$image_paths' WHERE pet_id = '$last_id'";
        $conn->query($updatesql);

        $response = array('success' => true, 'message' => 'Pet submitted successful');
       
        sendJsonResponse($response);
        exit();
    } else {
        $response = array('failed' => false, 'message' => 'Submission failed');
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array("error" => "An error occurred: " . $e->getMessage());
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>