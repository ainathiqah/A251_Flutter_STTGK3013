<h1 align="center">🐾 PawPal</h1>

<p align="center">
  <b>Pet Adoption & Donation Mobile App</b><br/>
  A continuous full-stack project built with Flutter, PHP, and MySQL
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/PHP-777BB4?style=flat&logo=php&logoColor=white" />
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white" />
</p>

---

## About

PawPal is an Android mobile application that connects pet lovers with animals in need. It enables pet adoption, pet donation, and community support through a simple, user-friendly platform.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Mobile UI) |
| Backend | PHP (REST API) |
| Database | MySQL |

---

## Application Capabilities

- Browse pets available for adoption
- Submit pets for adoption or donation
- Request pet adoption
- Donate money, food, or medical aid to pets in need

---

## Features

### 1. User Authentication
- User registration with validation
- Login with SHA-1 password hashing
- Session stored using SharedPreferences

### 2. Public Pet Listing
- View all pets
- Search by pet name
- Filter by category

### 3. Pet Submission
- Submit pet for adoption or donation
- Upload up to 3 images, encoded in Base64
- Stored using `file_put_contents()`
- Data saved in `tbl_pets`

### 4. Adoption Request
- Submit motivation message
- Input validation applied
- Stored in `tbl_adoptions`

### 5. Donation Module
- Donation types: Money, Food, Medical
- Donation form with validation
- Stored in `tbl_donation`

### 6. Profile Management
- View and edit user profile
- Upload profile image

---

## Screenshots

<table>
  <tr>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/e15b3ecd-4645-447d-bcdb-1182d40ef95b" width="160" /><br/>
      <sub><b>Login</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/5d0a86c6-9d52-4e75-937f-cc1aa55d8d2c" width="160" /><br/>
      <sub><b>Register</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/bf5006aa-1fc9-4eb0-b540-327d4cc96545" width="160" /><br/>
      <sub><b>Public Pet Listing</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/64afeeb5-bbd1-4eb9-900c-c8f314695be8" width="160" /><br/>
      <sub><b>Donation Option</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/d3ccd096-9864-43e6-b7ec-581830fbe51e" width="160" /><br/>
      <sub><b>Donation Page</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/1af7546f-9b03-4126-89cc-336aab1727d5" width="160" /><br/>
      <sub><b>Donation History</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/940e9fde-dd56-4cf4-bb8f-daa2a2206002" width="160" /><br/>
      <sub><b>Adoption Option</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/c00b55f2-731b-4f9d-a24c-db91c71ef900" width="160" /><br/>
      <sub><b>Adoption Status</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/d92f8002-3e48-4baf-a106-1fb40c867f44" width="160" /><br/>
      <sub><b>Adoption Records</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/8fe35173-0341-47a1-9366-5e3c69c4b532" width="160" /><br/>
      <sub><b>My Pet Page</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/fa9dae7c-7e1b-4d21-9f5a-410cabc9fbdb" width="160" /><br/>
      <sub><b>My Pet Submission</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/bffb8767-d6c5-41db-8c0f-e8cdccc9cc07" width="160" /><br/>
      <sub><b>My Profile</b></sub>
    </td>
  </tr>
</table>

---

## Database Tables

| Table | Purpose |
|---|---|
| `tbl_users` | User accounts and profile data |
| `tbl_pets` | Pet submissions for adoption or donation |
| `tbl_adoptions` | Adoption requests and status |
| `tbl_donation` | Money, food, and medical donations |
