# pawpal
Project Name : PawPal Pet Adoption & Donation App.

Description: PawPal Pet Adoption & Donation App is the first part of a continuous project series to develop a full-stack mobile app using Flutter (frontend) and PHP + MySQL (backend).

PawPal is an Android-based mobile application developed using:

- Flutter (Frontend)
- PHP (Backend)
- MySQL (Database)
  
The application allows users to:

- Browse pets available for adoption
- Submit pets for adoption or donation
- Request pet adoption
- Donate to pets in need

Features & Functionality

1. User Authentication
- User registration with validation
- Login with SHA-1 password hashing
- Session stored using SharedPreferences

2. Public Pet Listing
   
- View all pets
- Search by pet name
- Filter by category

3. Pet Submission

- Submit pet for adoption or donation
- Upload up to 3 images
- Images encoded in Base64
- Stored using file_put_contents()
- Data saved in tbl_pets

4. Adoption Request
   
- Submit motivation message
- Validation applied
- Stored in tbl_adoptions

5. Donation Module
- Donation types: Money, Food, Medical
- Form inputs
- Stored in tbl_donations

6. Profile Management
- View & edit profile
- Upload profile image
