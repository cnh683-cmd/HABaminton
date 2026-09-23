<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=38">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="login">

        <form action="loginServlet" method="POST" class="login__form">
            <h1 class="login__title">Đăng nhập</h1>
            
            <c:if test="${not empty error}">
                <p style="color: #dc3545; text-align: center; margin-bottom: 15px; font-weight: bold; font-size: 14px;">
                    ${error}
                </p>
            </c:if>

            <div class="login__inputs">
                <div class="login__box">
                    <input type="email" name="email" placeholder="Email của bạn" required class="login__input">
                    <i class="fa-solid fa-envelope"></i>
                </div>

                <div class="login__box">
                    <input type="password" name="password" placeholder="Mật khẩu" required class="login__input">
                    <i class="fa-solid fa-lock"></i>
                </div>
            </div>

            <div class="login__check">
                <div class="login__check-box">
                    <input type="checkbox" class="login__check-input" id="user-check">
                    <label for="user-check" class="login__check-label">Nhớ mật khẩu</label>
                </div>

                <a href="#" class="login__forgot">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="login__button">Đăng nhập</button>

            <div class="login__register">
                Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
            </div>
        </form>
    </div>
</body>
</html>