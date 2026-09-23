<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - HA Badminton</title>
    <!-- Đổi version CSS để tránh trình duyệt lưu cache -->
    <link rel="stylesheet" href="css/style.css?v=52">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <c:if test="${empty sessionScope.user}">
        <c:redirect url="login.jsp" />
    </c:if>

    <div class="container profile-page">
        <!-- CỘT TRÁI: THÔNG TIN SIDEBAR & AVATAR -->
        <div class="profile-sidebar">
            
            <label for="avatarUpload" class="profile-avatar" title="Thay đổi ảnh đại diện">
                <c:choose>
                    <c:when test="${not empty sessionScope.user.avatar}">
                        <img id="avatarPreview" src="${pageContext.request.contextPath}/${sessionScope.user.avatar}" alt="Avatar">
                        <i id="avatarIcon" class="fa-solid fa-address-card" style="display: none;"></i>
                    </c:when>
                    <c:otherwise>
                        <i id="avatarIcon" class="fa-solid fa-address-card"></i>
                        <img id="avatarPreview" src="" alt="Avatar" style="display: none;">
                    </c:otherwise>
                </c:choose>

                <!-- Lớp phủ Camera khi Hover -->
                <div class="avatar-overlay">
                    <i class="fa-solid fa-camera"></i>
                </div>
            </label>

            <!-- Input chọn file liên kết với thẻ form chính qua thuộc tính form="profileUpdateForm" -->
            <input type="file" id="avatarUpload" name="avatarFile" accept="image/*" style="display: none;" onchange="previewAvatar(this)" form="profileUpdateForm">
            
            <h3>${sessionScope.user.hoTen}</h3>
            <p>Email: ${sessionScope.user.email}</p>
            
            <div class="profile-menu">
                <a href="profile.jsp" class="active"><i class="fa-solid fa-shield-halved"></i> Hồ sơ bảo mật</a>
                <a href="logoutServlet" class="logout"><i class="fa-solid fa-power-off"></i> Đăng xuất</a>
            </div>
        </div>

        <!-- CỘT PHẢI: FORM CHỈNH SỬA THÔNG TIN -->
        <div class="profile-main">
            <div class="profile-header">
                <h2>Cài Đặt Tài Khoản</h2>
                <p>Quản lý thông tin cá nhân và địa chỉ giao hàng của bạn</p>
            </div>

            <!-- Bắt buộc phải có id="profileUpdateForm" và enctype="multipart/form-data" -->
            <form id="profileUpdateForm" action="UpdateProfileServlet" method="POST" class="profile-form" enctype="multipart/form-data">
                
                <!-- HÀNG 1: HỌ VÀ TÊN -->
                <div class="form-row" style="display: flex; gap: 15px; margin-bottom: 20px;">
                    <div class="form-group" style="flex: 1; margin: 0;">
                        <label style="display: block; font-size: 12px; color: #555; font-weight: 700; text-transform: uppercase; margin-bottom: 8px;">Họ</label>
                        <input type="text" id="hoInput" name="ho" class="profile-input" required style="width: 100%;">
                    </div>
                    <div class="form-group" style="flex: 1; margin: 0;">
                        <label style="display: block; font-size: 12px; color: #555; font-weight: 700; text-transform: uppercase; margin-bottom: 8px;">Tên</label>
                        <input type="text" id="tenInput" name="ten" class="profile-input" required style="width: 100%;">
                    </div>
                    <input type="hidden" id="hiddenFullName" value="${sessionScope.user.hoTen}">
                </div>

                <!-- HÀNG 2: EMAIL VÀ SỐ ĐIỆN THOẠI -->
                <div class="form-row" style="display: flex; gap: 15px; margin-bottom: 20px;">
                    <div class="form-group" style="flex: 1; margin: 0;">
                        <label style="display: block; font-size: 12px; color: #555; font-weight: 700; text-transform: uppercase; margin-bottom: 8px;">Địa chỉ Email</label>
                        <input type="email" class="profile-input" value="${sessionScope.user.email}" readonly style="width: 100%; background: #f5f5f5; cursor: not-allowed; color: #888;">
                    </div>
                    <div class="form-group" style="flex: 1; margin: 0;">
                        <label style="display: block; font-size: 12px; color: #555; font-weight: 700; text-transform: uppercase; margin-bottom: 8px;">Số điện thoại</label>
                        <input type="text" name="sdt" class="profile-input" value="${sessionScope.user.sdt}" style="width: 100%;">
                    </div>
                </div>

                <!-- HÀNG 3: ĐỊA CHỈ NHÀ -->
                <div class="form-group" style="margin-bottom: 20px;">
                    <label style="display: block; font-size: 12px; color: #555; font-weight: 700; text-transform: uppercase; margin-bottom: 8px;">Địa chỉ (Số nhà, tên đường...)</label>
                    <input type="text" name="diaChi" class="profile-input" value="${sessionScope.user.diaChi}" style="width: 100%;">
                </div>

                <!-- HÀNG 4: QUẬN/HUYỆN VÀ TỈNH/THÀNH PHỐ -->
                <div class="form-row" style="display: flex; gap: 15px; margin-bottom: 30px;">
                    <div class="form-group" style="flex: 1; margin: 0;">
                        <label style="display: block; font-size: 12px; color: #555; font-weight: 700; text-transform: uppercase; margin-bottom: 8px;">Quận / Huyện</label>
                        <input type="text" name="quanHuyen" class="profile-input" value="${sessionScope.user.quanHuyen}" style="width: 100%;">
                    </div>
                    <div class="form-group" style="flex: 1; margin: 0;">
                        <label style="display: block; font-size: 12px; color: #555; font-weight: 700; text-transform: uppercase; margin-bottom: 8px;">Tỉnh / Thành phố</label>
                        <input type="text" name="tinhThanh" class="profile-input" value="${sessionScope.user.tinhThanh}" style="width: 100%;">
                    </div>
                </div>

                <!-- NÚT CẬP NHẬT -->
                <div style="border-top: 1px solid #eee; padding-top: 20px; display: flex; justify-content: space-between; align-items: center;">
                    <button type="submit" class="btn-update-profile">CẬP NHẬT NGAY <i class="fa-solid fa-arrow-right"></i></button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp"></jsp:include>

    <!-- 1. SCRIPT XEM TRƯỚC ẢNH (Phải đặt bên ngoài thẻ c:if) -->
    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    var preview = document.getElementById('avatarPreview');
                    var icon = document.getElementById('avatarIcon');
                    
                    // Ẩn icon đi nếu đang có
                    if (icon) {
                        icon.style.display = 'none';
                    }
                    
                    // Hiển thị thẻ img và gán nguồn ảnh vừa tải
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>

    <!-- 2. SCRIPT TỰ ĐỘNG TÁCH HỌ TÊN -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            let fullNameNode = document.getElementById("hiddenFullName");
            if (fullNameNode && fullNameNode.value) {
                let fullName = fullNameNode.value.trim();
                if (fullName.length > 0) {
                    let lastSpaceIndex = fullName.lastIndexOf(" ");
                    if (lastSpaceIndex !== -1) {
                        document.getElementById("hoInput").value = fullName.substring(0, lastSpaceIndex);
                        document.getElementById("tenInput").value = fullName.substring(lastSpaceIndex + 1);
                    } else {
                        document.getElementById("tenInput").value = fullName;
                    }
                }
            }
        });
    </script>
    
    <!-- 3. HIỂN THỊ THÔNG BÁO NẾU CẬP NHẬT THÀNH CÔNG -->
    <c:if test="${not empty sessionScope.msgSuccess}">
        <div id="toastSuccess" style="position: fixed; top: 30px; right: 30px; background: #00a152; color: white; padding: 15px 25px; border-radius: 8px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); z-index: 9999; display: flex; align-items: center; gap: 10px; font-weight: 600; font-family: sans-serif; animation: slideInRight 0.5s ease forwards;">
            <i class="fa-solid fa-circle-check" style="font-size: 20px;"></i>
            <span>${sessionScope.msgSuccess}</span>
        </div>
        <style>
            @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
            @keyframes fadeOutRight { from { transform: translateX(0); opacity: 1; } to { transform: translateX(100%); opacity: 0; } }
        </style>
        <script>
            setTimeout(function() {
                let toast = document.getElementById("toastSuccess");
                if (toast) {
                    toast.style.animation = "fadeOutRight 0.5s ease forwards";
                    setTimeout(() => toast.remove(), 500);
                }
            }, 3000);
        </script>
        <c:remove var="msgSuccess" scope="session"/>
    </c:if>
</body>
</html>