<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của bạn - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=46">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* CSS TÔ ĐỎ ĐƠN HÀNG BỊ HỦY CHO USER */
        .cancelled-card { border-color: #ffcdd2 !important; }
        .cancelled-card .moc-header { background-color: #fff5f5 !important; border-bottom: 1px solid #ffcdd2 !important; }
        .moc-cancel-reason {
            width: 100%; padding: 12px 25px; background: #fff5f5; 
            color: #dc3545; font-size: 14px; border-bottom: 1px dashed #ffcdd2;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <div class="container orders-page" style="min-height: 65vh; margin-bottom: 50px;">
        <h2 class="orders-title" style="margin-bottom: 30px;">ĐƠN HÀNG CỦA TÔI</h2>
        
        <c:forEach items="${listOrders}" var="o">
            <div class="modern-order-card ${o.trangThai == 0 ? 'cancelled-card' : ''}">
                <!-- 1. Header: Thông tin chung & Nút Xem -->
                <div class="moc-header">
                    <div class="moc-col">
                        <span class="moc-label">Mã đơn hàng:</span>
                        <span class="moc-val">#${o.maDonHang}</span>
                    </div>
                    
                    <div class="moc-col">
                        <span class="moc-label">Ngày đặt:</span>
                        <span class="moc-val"><fmt:formatDate value="${o.ngayDat}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                    
                    <div class="moc-col">
                        <span class="moc-label">Trạng thái:</span>
                        <div style="display: flex; align-items: center;">
                            <c:choose>
                                <c:when test="${o.trangThai == 1}"><span class="moc-status status-1">Chờ xác nhận</span></c:when>
                                <c:when test="${o.trangThai == 2}"><span class="moc-status status-2">Đã tiếp nhận đơn hàng</span></c:when>
                                <c:when test="${o.trangThai == 3}"><span class="moc-status status-3">Đang giao hàng</span></c:when>
                                <c:when test="${o.trangThai == 4}"><span class="moc-status status-4">Đã giao hàng</span></c:when>
                                <c:otherwise><span class="moc-status status-0">Đã hủy</span></c:otherwise>
                            </c:choose>
                            
                            <!-- Báo MỚI khi có thay đổi -->
                            <c:if test="${o.userDaXem == 0}">
                                <span class="badge-new">MỚI</span>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="moc-action">
                        <a href="order-detail?id=${o.maDonHang}" class="btn-moc-view">Xem hóa đơn</a>
                    </div>
                </div>

                <!-- Hiển thị thanh lý do hủy ngay dưới Header cho User -->
                <c:if test="${o.trangThai == 0}">
                    <div class="moc-cancel-reason">
                        <i class="fa-solid fa-circle-exclamation"></i> <strong>Đơn hàng đã bị hủy. Lý do:</strong> ${not empty o.lyDoHuy ? o.lyDoHuy : 'Không có lý do cụ thể'}
                    </div>
                </c:if>

                <!-- 2. Body: Danh sách sản phẩm -->
                <div class="moc-body">
                    <c:set var="subTotal" value="0" />
                    <c:forEach items="${o.chiTietList}" var="item">
                        <c:set var="subTotal" value="${subTotal + (item.giaMua * item.soLuong)}" />
                        <div class="moc-product">
                            <img src="${item.hinhAnh}" alt="${item.tenSP}">
                            <div class="moc-prod-info">
                                <h4>${item.tenSP}</h4>
                                <p>Số lượng: <strong>${item.soLuong}</strong></p>
                            </div>
                            <div class="moc-prod-price">
                                <fmt:formatNumber value="${item.giaMua}" pattern="#,###"/>đ
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 3. Footer: Voucher & Tổng tiền -->
                <div class="moc-footer">
                    <div class="moc-summary">
                        <c:if test="${not empty o.maVoucher}">
                            <c:set var="discountAmt" value="${subTotal - o.tongTien}" />
                            <div class="moc-voucher">
                                <i class="fa-solid fa-ticket"></i> Mã áp dụng: <strong>${o.maVoucher}</strong>
                                <c:if test="${discountAmt > 0}">
                                    <span class="moc-discount">(-<fmt:formatNumber value="${discountAmt}" pattern="#,###"/>đ)</span>
                                </c:if>
                            </div>
                        </c:if>
                        <div class="moc-total">
                            <span>Tổng tiền hóa đơn:</span>
                            <strong class="moc-final-price"><fmt:formatNumber value="${o.tongTien}" pattern="#,###"/>đ</strong>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty listOrders}">
            <p style="text-align: center; color: #888; margin-top: 50px; font-size: 16px;">Bạn chưa có đơn hàng nào.</p>
        </c:if>
    </div>
    
    <script>
        if (window.location.search.includes('clearCart=true')) {
            localStorage.removeItem('habadminton_cart'); 
            if (typeof renderCart === 'function') {
                cart = [];
                renderCart(); 
            }
            window.history.replaceState({}, document.title, "orders");
        }
    </script>
    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>