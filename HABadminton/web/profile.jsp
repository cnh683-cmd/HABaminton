<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=41">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <!-- Bắt buộc phải đăng nhập mới xem được trang này -->
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="login.jsp" />
    </c:if>

    <div class="container profile-page">
        <!-- Cột trái (Sidebar) -->
        <div class="profile-sidebar">
            <div class="profile-avatar">
                <i class="fa-regular fa-id-badge"></i>
            </div>
            <h3>${sessionScope.user.hoTen}</h3>
            <p>Email: ${sessionScope.user.email}</p>
            
            <div class="profile-menu">
                <a href="profile.jsp" class="active"><i class="fa-solid fa-shield-halved"></i> Hồ sơ bảo mật</a>
                <a href="logoutServlet" class="logout"><i class="fa-solid fa-power-off"></i> Đăng xuất</a>
            </div>
        </div>

        <!-- Cột phải (Form) -->
        <div class="profile-main">
            <div class="profile-header">
                <h2>Cài Đặt Tài Khoản</h2>
                <p>Quản lý thông tin cá nhân và địa chỉ giao hàng của bạn</p>
            </div>

            <form action="UpdateProfileServlet" method="POST" class="profile-form">
                <div class="form-row-2">
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="hoTen" class="profile-input" value="${sessionScope.user.hoTen}" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="sdt" class="profile-input" value="${sessionScope.user.sdt}">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label>Địa chỉ Email (Không thể thay đổi)</label>
                    <input type="email" class="profile-input" value="${sessionScope.user.email}" readonly>
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label>Địa chỉ (Số nhà, tên đường...)</label>
                    <input type="text" name="diaChi" class="profile-input" value="${sessionScope.user.diaChi}">
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label>Quận / Huyện</label>
                        <input type="text" name="quanHuyen" class="profile-input" value="${sessionScope.user.quanHuyen}">
                    </div>
                    <div class="form-group">
                        <label>Tỉnh / Thành phố</label>
                        <input type="text" name="tinhThanh" class="profile-input" value="${sessionScope.user.tinhThanh}">
                    </div>
                </div>

                <div style="border-top: 1px solid #eee; padding-top: 20px; display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-size: 13px; color: #28a745;"><i class="fa-solid fa-shield-check"></i> Thông tin của bạn được bảo mật tuyệt đối</span>
                    <button type="submit" class="btn-update-profile">CẬP NHẬT NGAY <i class="fa-solid fa-arrow-right"></i></button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>