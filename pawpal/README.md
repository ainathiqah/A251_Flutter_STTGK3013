# pawpal
<p>
  <b>PawPal Pet Adoption & Donation App</b> is the <b>continuous full-stack project series</b>,
  focused on developing a real-world mobile application using
  <b>Flutter (frontend)</b> and <b>PHP + MySQL (backend)</b>.
</p>

<p>
  PawPal is an <b>Android-based mobile application</b> designed to connect pet lovers with animals in need by
  enabling <b>pet adoption</b>, <b>pet donation</b>, and <b>community support</b> through a simple and
  user-friendly platform.
</p>

<hr/>

<h3>Tech Stack</h3>
<ul>
  <li><b>Flutter</b> – Frontend (Mobile UI)</li>
  <li><b>PHP</b> – Backend (REST API)</li>
  <li><b>MySQL</b> – Database</li>
</ul>

<hr/>

<h3>Application Capabilities</h3>
<ul>
  <li>Browse pets available for <b>adoption</b></li>
  <li>Submit pets for <b>adoption or donation</b></li>
  <li>Request pet <b>adoption</b></li>
  <li>Donate <b>money, food, or medical aid</b> to pets in need</li>
</ul>

<hr/>

<h3>Features & Functionality</h3>

<h4>1. User Authentication</h4>
<ul>
  <li>User registration with validation</li>
  <li>Login with <b>SHA-1 password hashing</b></li>
  <li>Session stored using <b>SharedPreferences</b></li>
</ul>

<h4>2. Public Pet Listing</h4>
<ul>
  <li>View all pets</li>
  <li>Search by pet name</li>
  <li>Filter by category</li>
</ul>

<h4>3. Pet Submission</h4>
<ul>
  <li>Submit pet for adoption or donation</li>
  <li>Upload up to <b>3 images</b></li>
  <li>Images encoded in <b>Base64</b></li>
  <li>Stored using <code>file_put_contents()</code></li>
  <li>Data saved in <b>tbl_pets</b></li>
</ul>

<h4>4. Adoption Request</h4>
<ul>
  <li>Submit motivation message</li>
  <li>Input validation applied</li>
  <li>Stored in <b>tbl_adoptions</b></li>
</ul>

<h4>5. Donation Module</h4>
<ul>
  <li>Donation types:
    <ul>
      <li>Money</li>
      <li>Food</li>
      <li>Medical</li>
    </ul>
  </li>
  <li>Donation form with validation</li>
  <li>Stored in <b>tbl_donations</b></li>
</ul>

<h4>6. Profile Management</h4>
<ul>
  <li>View & edit user profile</li>
  <li>Upload profile image</li>
</ul>

## App Screenshots

<table>
  <!-- Row 1 -->
  <tr>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/e15b3ecd-4645-447d-bcdb-1182d40ef95b" />
      <br/>Login
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/5d0a86c6-9d52-4e75-937f-cc1aa55d8d2c" />
      <br/>Register
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/bf5006aa-1fc9-4eb0-b540-327d4cc96545" />
      <br/>Public Pet Listing
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/64afeeb5-bbd1-4eb9-900c-c8f314695be8" />
      <br/>Donation Option
    </td>
  </tr>

  <!-- Spacer -->
  <tr>
    <td colspan="4"><br/></td>
  </tr>

  <!-- Row 2 -->
  <tr>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/d3ccd096-9864-43e6-b7ec-581830fbe51e" />
      <br/>Donation Page
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/1af7546f-9b03-4126-89cc-336aab1727d5" />
      <br/>Donation History
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/940e9fde-dd56-4cf4-bb8f-daa2a2206002" />
      <br/>Adoption Option
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/c00b55f2-731b-4f9d-a24c-db91c71ef900" />
      <br/>Adoption Pending / Status
    </td>
  </tr>

  <!-- Spacer -->
  <tr>
    <td colspan="4"><br/></td>
  </tr>

  <!-- Row 3 -->
  <tr>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/d92f8002-3e48-4baf-a106-1fb40c867f44" />
      <br/>Adoption Records
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/8fe35173-0341-47a1-9366-5e3c69c4b532" />
      <br/>My Pet Page
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/fa9dae7c-7e1b-4d21-9f5a-410cabc9fbdb" />
      <br/>My Pet Submission
    </td>
    <td align="center">
      <img width="200" height="500" src="https://github.com/user-attachments/assets/bffb8767-d6c5-41db-8c0f-e8cdccc9cc07" />
      <br/>My Profile
    </td>
  </tr>
</table>



