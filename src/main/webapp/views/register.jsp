<%--
  Created by IntelliJ IDEA.
  User: agraz
  Date: 5/3/2026
  Time: 8:51 PM
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Smart Waste Management</title>
    <link rel="stylesheet" type="text/css" href="../css/register.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
</head>
<body>
<div class="container">
    <div class="register-box">
        <h2>Register</h2>
        <form id="registerForm" action="register" method="post">
            <label for="name">Full Name</label>
            <input
                    type="text"
                    id="name"
                    name="name"
                    placeholder="Enter full name"
            />
            <span id="nameError" class="error-message" style="display: none"
            >Full name is required</span
            >

            <label for="email">Email</label>
            <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter email"
            />
            <span id="emailError" class="error-message" style="display: none"
            >Email is required</span
            >

            <label for="password">Password</label>
            <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Enter password"
            />
            <span id="passwordError" class="error-message" style="display: none"
            >Password is required</span
            >
            <button type="submit">Register</button>
            <span class="cta">
                Already have an account? <a href="./login.jsp" style="text-decoration: underline;">Login Here</a>
          </span>
        </form>
    </div>
</div>

<script>
    document
        .getElementById("registerForm")
        .addEventListener("submit", function (event) {
            event.preventDefault();

            let name = document.getElementById("name");
            let email = document.getElementById("email");
            let password = document.getElementById("password");

            let nameValue = name.value;
            let emailValue = email.value;
            let passwordValue = password.value;

            let nameError = document.getElementById("nameError");
            let emailError = document.getElementById("emailError");
            let passwordError = document.getElementById("passwordError");

            if (nameValue === "") {
                nameError.style.display = "block";
                nameError.style.color = "red";
            } else {
                nameError.style.display = "none";
            }

            if (emailValue === "") {
                emailError.style.display = "block";
                emailError.style.color = "red";
            } else {
                emailError.style.display = "none";
            }

            if (passwordValue === "") {
                passwordError.style.display = "block";
                passwordError.style.color = "red";
            } else {
                passwordError.style.display = "none";
            }

            if (nameValue !== "" && emailValue !== "" && passwordValue !== "") {
                this.submit();
            }
        });
</script>
</body>
</html>
