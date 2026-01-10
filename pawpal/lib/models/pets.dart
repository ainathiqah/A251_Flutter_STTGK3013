class Pets {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? petAge;
  String? petGender;
  String? petHealth;
  String? category;
  String? adoptionStatus;
  String? description;
  String? imagePaths;
  String? lat;
  String? lng;
  String? createdAt;
  
  //Owner info
  String? name;
  String? email;
  String? phone;

  Pets({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.petAge,
    this.petGender,
    this.petHealth,
    this.category,
    this.adoptionStatus,
    this.description,
    this.imagePaths,
    this.lat,
    this.lng,
    this.createdAt,
    this.name,
    this.email,
    this.phone,
  });

  Pets.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petType = json['pet_type'];
    petAge = json['pet_age'];
    petGender = json['pet_gender'];
    petHealth = json['pet_health'];
    category = json['category'];
    adoptionStatus = json['adoption_status'];
    description = json['description'];
    imagePaths = json['image_paths'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['created_at'];

    name = json['name'];
    email = json['email'];  
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['pet_age'] = petAge;
    data['pet_gender'] = petGender;
    data['pet_health'] = petHealth;
    data['category'] = category;
    data['adoption_status'] = adoptionStatus;
    data['description'] = description;
    data['image_paths'] = imagePaths;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = createdAt;
    
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
