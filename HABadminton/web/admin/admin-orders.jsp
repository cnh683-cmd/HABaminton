<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <style>
        /* CSS TÔ ĐỎ ĐƠN HÀNG BỊ HỦY CHO ADMIN */
        .cancelled-card { border-color: rgba(220, 53, 69, 0.5) !important; }
        .cancelled-card .ad-oc-header { background-color: rgba(220, 53, 69, 0.08) !important; border-bottom: 1px solid rgba(220, 53, 69, 0.3) !important; }
        .ad-cancel-reason {
            width: 100%; padding: 12px 24px; background: rgba(220, 53, 69, 0.1); 
            color: #ff6b6b; font-size: 14px; border-bottom: 1px solid var(--border-thin);
        }
    </style>
</head>
<body>

    <jsp:include page="admin-sidebar.jsp">
        <jsp:param name="active" value="orders" />
    </jsp:include>

    <div class="admin-main">
        <h2 class="admin-page-title">Quản lý đơn hàng</h2>

        <form action="${pageContext.request.contextPath}/admin-orders" method="GET" class="filter-bar">
            <input type="text" name="keyword" value="${keyword}" class="filter-input" placeholder="Tìm mã đơn, tên khách hoặc SĐT...">
            <select name="status" class="filter-select">
                <option value="all">Tất cả trạng thái</option>
                <option value="1" ${status == '1' ? 'selected' : ''}>Chờ xác nhận</option>
                <option value="2" ${status == '2' ? 'selected' : ''}>Đã tiếp nhận</option>
                <option value="3" ${status == '3' ? 'selected' : ''}>Đang giao hàng</option>
                <option value="4" ${status == '4' ? 'selected' : ''}>Đã giao hàng</option>
                <option value="0" ${status == '0' ? 'selected' : ''}>Đã hủy</option>
            </select>
            <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
            <a href="${pageContext.request.contextPath}/admin-orders" class="btn-reset"><i class="fa-solid fa-rotate-right"></i> Làm mới</a>
        </form>

        <c:forEach items="${listOrders}" var="o">
            <!-- Đổi màu viền nếu đơn bị hủy -->
            <div class="ad-order-card ${o.trangThai == 0 ? 'cancelled-card' : ''}" id="order-${o.maDonHang}">
                
                <div class="ad-oc-header">
                    <div>
                        <div class="ad-oc-id"><i class="fa-solid fa-receipt"></i> #${o.maDonHang}</div>
                        <div class="ad-oc-time"><i class="fa-regular fa-clock"></i> <fmt:formatDate value="${o.ngayDat}" pattern="dd/MM/yyyy - HH:mm" /></div>
                    </div>
                    
                    <div class="ad-oc-actions">
                        <span class="ad-oc-price"><fmt:formatNumber value="${o.tongTien}" pattern="#,###"/> đ</span>
                        
                        <!-- Lưu lại giá trị hiện tại (data-current) để hoàn tác nếu Admin không nhập lý do -->
                        <select class="status-select" data-current="${o.trangThai}" onchange="handleStatusChange('${o.maDonHang}', this)">
                            <option value="1" ${o.trangThai == 1 ? 'selected' : ''}>Chờ xác nhận</option>
                            <option value="2" ${o.trangThai == 2 ? 'selected' : ''}>Đã tiếp nhận</option>
                            <option value="3" ${o.trangThai == 3 ? 'selected' : ''}>Đang giao hàng</option>
                            <option value="4" ${o.trangThai == 4 ? 'selected' : ''}>Đã giao hàng</option>
                            <option value="0" ${o.trangThai == 0 ? 'selected' : ''}>Đã hủy</option>
                        </select>
                        
                        <!-- Trả lại nút thùng rác dùng để XÓA -->
                        <button class="btn-delete" onclick="deleteOrder('${o.maDonHang}')"><i class="fa-solid fa-trash-can"></i></button>
                    </div>
                </div>

                <!-- Hiển thị thanh lý do hủy ngay dưới Header -->
                <c:if test="${o.trangThai == 0}">
                    <div class="ad-cancel-reason">
                        <i class="fa-solid fa-circle-exclamation"></i> <strong>Đơn hàng đã bị hủy. Lý do:</strong> ${not empty o.lyDoHuy ? o.lyDoHuy : 'Không có lý do cụ thể'}
                    </div>
                </c:if>

                <div class="ad-oc-body">
                    <div>
                        <div class="ad-col-title">${o.chiTietList.size()} SẢN PHẨM</div>
                        <c:forEach items="${o.chiTietList}" var="item">
                            <div class="ad-product-item">
                                <img src="${item.hinhAnh}" alt="${item.tenSP}">
                                <div class="ad-prod-info">
                                    <h4>${item.tenSP}</h4>
                                    <p>SL: x${item.soLuong}</p>
                                    <p style="color: var(--rose-copper); font-weight: bold;"><fmt:formatNumber value="${item.giaMua}" pattern="#,###"/> đ</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div>
                        <div class="ad-col-title"><i class="fa-solid fa-user"></i> THÔNG TIN KHÁCH HÀNG</div>
                        <div class="ad-cust-info">
                            <span>Tên:</span> <strong>${o.tenNguoiNhan}</strong>
                            <span>SĐT:</span> <strong>${o.sdt}</strong>
                            <span>Đ/c:</span> <strong>${o.diaChi}</strong>
                        </div>
                        <div class="ad-note-box">
                            <i class="fa-solid fa-pen-to-square"></i> 
                            ${empty o.ghiChu ? 'Không có ghi chú' : o.ghiChu}
                        </div>
                    </div>

                    <div>
                        <div class="ad-col-title"><i class="fa-solid fa-credit-card"></i> THANH TOÁN</div>
                        
                        <div class="ad-pay-info">
                            <span>Phương thức:</span> 
                            <strong>${o.phuongThucThanhToan == 'MOMO' ? 'Ví MoMo' : 'Tiền mặt (COD)'}</strong>
                        </div>
                        
                        <c:if test="${not empty o.maVoucher}">
                            <div class="ad-pay-info">
                                <span>Voucher:</span> 
                                <strong style="color: var(--rose-copper);">${o.maVoucher}</strong>
                            </div>
                        </c:if>

                        <div style="text-align: right; margin-top: 15px;" id="pay-status-${o.maDonHang}">
                            <c:choose>
                                <c:when test="${o.phuongThucThanhToan == 'MOMO'}">
                                    <span class="pay-status pay-success">✔ Đã thanh toán (MoMo)</span>
                                </c:when>
                                <c:when test="${o.phuongThucThanhToan == 'COD' and o.trangThai == 4}">
                                    <span class="pay-status pay-success">✔ Đã thu tiền mặt (COD)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="pay-status pay-pending">x Chưa thanh toán</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty listOrders}">
            <p class="empty-msg">Không tìm thấy đơn hàng nào.</p>
        </c:if>
    </div>

    <script>
        // Hàm Xử lý khi Admin đổi trạng thái sang "Đã hủy" (0)
        function handleStatusChange(id, selectElement) {
            let statusValue = selectElement.value;
            let currentValue = selectElement.getAttribute('data-current');

            if (statusValue === '0') {
                let reason = prompt("Nhập lý do hủy đơn hàng #" + id + ":");
                if (reason != null && reason.trim() !== "") {
                    // Chuyển hướng sang Servlet xử lý Hủy đơn
                    window.location.href = "${pageContext.request.contextPath}/cancel-order?id=" + id + "&reason=" + encodeURIComponent(reason) + "&from=admin";
                } else {
                    alert("Vui lòng nhập lý do để hủy đơn!");
                    selectElement.value = currentValue; // Hủy thao tác, trả về trạng thái cũ
                }
            } else {
                changeStatus(id, statusValue); // Gọi hàm cập nhật bình thường
            }
        }

        // Hàm cập nhật trạng thái bình thường (1, 2, 3, 4)
        function changeStatus(id, statusValue) {
            fetch('${pageContext.request.contextPath}/update-order', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=updateStatus&id=' + id + '&status=' + statusValue
            })
            .then(response => response.text())
            .then(data => {
                if(data === 'success') {
                    let payStatusDiv = document.getElementById('pay-status-' + id);
                    if(statusValue === '4' && payStatusDiv.innerHTML.includes('Chưa thanh toán')) {
                        payStatusDiv.innerHTML = '<span class="pay-status pay-success">✔ Đã thu tiền mặt (COD)</span>';
                    } else if (statusValue !== '4' && payStatusDiv.innerHTML.includes('Đã thu tiền mặt')) {
                        payStatusDiv.innerHTML = '<span class="pay-status pay-pending">x Chưa thanh toán</span>';
                    }
                    // Cập nhật lại data-current sau khi update thành công
                    document.querySelector('#order-' + id + ' .status-select').setAttribute('data-current', statusValue);
                } else {
                    alert("Lỗi cập nhật trạng thái!");
                }
            });
        }

        // Hàm XÓA VĨNH VIỄN
        function deleteOrder(id) {
            if(confirm("Bạn có chắc chắn muốn XÓA VĨNH VIỄN đơn hàng #" + id + " không?")) {
                fetch('${pageContext.request.contextPath}/update-order', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=delete&id=' + id
                })
                .then(response => response.text())
                .then(data => {
                    if(data === 'success') {
                        document.getElementById('order-' + id).remove();
                    } else {
                        alert("Không thể xóa đơn hàng này!");
                    }
                });
            }
        }
    </script>
</body>
</html>