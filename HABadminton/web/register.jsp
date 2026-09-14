<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=38">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="login">

        <form action="registerServlet" method="POST" class="login__form">
            <h1 class="login__title">Đăng ký</h1>

            <div class="login__inputs">
                <div class="login__box">
                    <input type="text" name="fullname" placeholder="Họ và tên" required class="login__input">
                    <i class="fa-solid fa-user"></i>
                </div>

                <div class="login__box">
                    <input type="email" name="email" placeholder="Email" required class="login__input">
                    <i class="fa-solid fa-envelope"></i>
                </div>

                <div class="login__box">
                    <input type="password" name="password" placeholder="Mật khẩu" required class="login__input">
                    <i class="fa-solid fa-lock"></i>
                </div>

                <div class="login__box">
                    <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required class="login__input">
                    <i class="fa-solid fa-shield-check"></i>
                </div>
            </div>

            <button type="submit" class="login__button">Đăng ký</button>

            <div class="login__register">
                Đã có tài khoản? <a href="login.jsp">Đăng nhập</a>
            </div>
        </form>
    </div>
</body>
</html>