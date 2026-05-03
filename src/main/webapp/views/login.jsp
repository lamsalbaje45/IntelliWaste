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
    <title>Login and Register Form</title>
    <link rel="stylesheet" type="text/css" href="../css/login.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
</head>
<body>
<div class="container">
    <div class="login-box">
        <h2>Login</h2>
        <form id="loginForm" action="login" method="post">
            <label for="username">Username</label>
            <input
                    type="text"
                    id="username"
                    name="username"
                    placeholder="Enter username"
            />
            <span id="usernameError" class="error-message" style="display: none"
            >Username is required</span
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
            <button type="submit">Login</button>
            <span class="cta">
                Don't have an account yet? <a href="./register.jsp" style="text-decoration: underline;">Register Here</a>
          </span>
        </form>
    </div>
</div>

<script>
    document
        .getElementById("loginForm")
        .addEventListener("submit", function (event) {
            event.preventDefault();

            let username = document.getElementById("username");
            let password = document.getElementById("password");

            let usernameValue = username.value;
            let passwordValue = password.value;

            let usernameError = document.getElementById("usernameError");
            let passwordError = document.getElementById("passwordError");

            if (usernameValue === "") {
                usernameError.style.display = "block";
                usernameError.style.color = "red";
            } else {
                usernameError.style.display = "none";
            }

            if (passwordValue === "") {
                passwordError.style.display = "block";
                passwordError.style.color = "red";
            } else {
                passwordError.style.display = "none";
            }

            if (usernameValue !== "" && passwordValue !== "") {
                this.submit();
            }
        });
</script>
</body>
</html>
