<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=47">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <div class="container od-page-wrapper">
        <!-- 1. HEADER CHI TIẾT -->
        <div class="od-top-header">
            <h2>Chi tiết đơn hàng</h2>
            <span class="od-id">Mã đơn hàng: #${order.maDonHang}</span>
        </div>

        <div class="od-main-layout">
            <!-- CỘT TRÁI: THÔNG TIN HÓA ĐƠN CỦA BẠN -->
            <div class="od-left-col">
                <h3 class="od-box-title">Hóa đơn của bạn</h3>
                
                <c:set var="subTotal" value="0" />
                <div class="od-products">
                    <c:forEach items="${order.chiTietList}" var="item">
                        <c:set var="subTotal" value="${subTotal + (item.giaMua * item.soLuong)}" />
                        <div class="od-item">
                            <img src="${item.hinhAnh}" alt="${item.tenSP}">
                            <div class="od-item-info">
                                <h4>${item.tenSP}</h4>
                                <p>SL: ${item.soLuong}</p>
                            </div>
                            <div class="od-item-price">
                                <fmt:formatNumber value="${item.giaMua}" pattern="#,###"/>đ<br>
                                <del style="color: #999; font-size: 12px;"></del>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="od-summary">
                    <div class="od-sum-row">
                        <span>Tạm tính</span>
                        <span><fmt:formatNumber value="${subTotal}" pattern="#,###"/>đ</span>
                    </div>
                    <div class="od-sum-row">
                        <span>Phí vận chuyển</span>
                        <span>Miễn phí</span>
                    </div>
                    
                    <!-- BẮT BUỘC ĐẶT BIẾN TÍNH TOÁN Ở ĐÂY -->
                    <c:set var="discountAmount" value="${subTotal - order.tongTien}" />
                    
                    <!-- RỒI MỚI KIỂM TRA ĐIỀU KIỆN ĐỂ HIỂN THỊ -->
                    <c:if test="${not empty order.maVoucher and discountAmount > 0}">
                        <div class="od-sum-row od-discount">
                            <span>Voucher áp dụng (${order.maVoucher})</span>
                            <span>-<fmt:formatNumber value="${discountAmount}" pattern="#,###"/>đ</span>
                        </div>
                    </c:if>
                    
                    <div class="od-sum-row od-total-row">
                        <span>Tổng hóa đơn</span>
                        <span><fmt:formatNumber value="${order.tongTien}" pattern="#,###"/>đ</span>
                    </div>
                </div>

                <div class="od-note-section">
                    <p class="od-note-title">Ghi chú đơn hàng:</p>
                    <p class="od-note-text">${empty order.ghiChu ? 'Không có ghi chú nào cho đơn hàng này.' : order.ghiChu}</p>
                </div>

                <div class="od-payment-info">
                    <p class="od-pay-title">Thông tin thanh toán</p>
                    <p class="od-pay-method">${order.phuongThucThanhToan == 'MOMO' ? 'Ví MoMo' : 'Tiền mặt (COD)'}</p>
                    <p class="od-pay-status ${order.trangThai >= 2 ? 'text-green' : 'text-red'}">
                        ${order.trangThai >= 2 ? '✔ Đã thanh toán' : 'x Chưa thanh toán'}
                    </p>
                </div>
            </div>

            <!-- CỘT PHẢI: TRẠNG THÁI VÀ GIAO HÀNG -->
            <div class="od-right-col">
                <!-- Thanh Tiến Trình Ngang -->
                <div class="od-progress-track">
                    <div class="od-step active">
                        <div class="od-icon"><i class="fa-solid fa-receipt"></i></div>
                        <p>Chờ xác nhận</p>
                        <span><fmt:formatDate value="${order.ngayDat}" pattern="dd-MM-yyyy HH:mm" /></span>
                    </div>
                    <div class="od-step ${order.trangThai >= 2 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-wallet"></i></div>
                        <p>Đã tiếp nhận</p>
                    </div>
                    <div class="od-step ${order.trangThai >= 3 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-truck-fast"></i></div>
                        <p>Đang giao hàng</p>
                    </div>
                    <div class="od-step ${order.trangThai >= 4 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-box-open"></i></div>
                        <p>Đã giao hàng</p>
                    </div>
                </div>

                <!-- Lời nhắc & Nút -->
                <div class="od-action-box">
                    <div class="od-delivery-est">
                        Dự kiến giao hàng vào khoảng 3-5 ngày tới
                    </div>
                    <div class="od-buttons">
                        <button class="btn-purple">Đã nhận được hàng</button>
                        <button class="btn-outline">Yêu cầu Trả hàng / Hoàn tiền</button>
                    </div>
                    <p class="od-confirm-text">Vui lòng chỉ ấn "Đã nhận được hàng" khi đơn hàng đã được giao đến bạn và sản phẩm không có vấn đề nào.</p>
                </div>
                
                <!-- Dải viền màu -->
                <div class="od-mail-border"></div>

                <!-- Thông tin & Timeline -->
                <div class="od-bottom-split">
                    <!-- Trái: Địa chỉ -->
                    <div class="od-address">
                        <h3>Địa chỉ nhận hàng</h3>
                        <strong>${order.tenNguoiNhan}</strong>
                        <p>${order.sdt}</p>
                        <p>${order.diaChi}</p>
                    </div>
                    
                    <!-- Phải: Timeline dọc -->
                    <div class="od-timeline">
                        <c:if test="${order.trangThai >= 4}">
                            <div class="tl-row active">
                                <span class="tl-time"><fmt:formatDate value="${order.ngayNhanHang}" pattern="dd-MM-yyyy HH:mm" /></span>
                                <div class="tl-dot"><i class="fa-solid fa-check"></i></div>
                                <span class="tl-desc">Đơn hàng đã giao thành công</span>
                            </div>
                        </c:if>
                        <c:if test="${order.trangThai >= 3}">
                            <div class="tl-row">
                                <span class="tl-time"><fmt:formatDate value="${order.ngayGiaoVan}" pattern="dd-MM-yyyy HH:mm" /></span>
                                <div class="tl-dot"><i class="fa-solid fa-truck"></i></div>
                                <span class="tl-desc">Đơn hàng đã được giao cho Đơn vị vận chuyển</span>
                            </div>
                        </c:if>
                        <c:if test="${order.trangThai >= 2}">
                            <div class="tl-row">
                                <span class="tl-time"><fmt:formatDate value="${order.ngayTiepNhan}" pattern="dd-MM-yyyy HH:mm" /></span>
                                <div class="tl-dot"><i class="fa-solid fa-box"></i></div>
                                <span class="tl-desc">Cửa hàng đang chuẩn bị đơn hàng</span>
                            </div>
                        </c:if>
                        <div class="tl-row">
                            <span class="tl-time"><fmt:formatDate value="${order.ngayDat}" pattern="dd-MM-yyyy HH:mm" /></span>
                            <div class="tl-dot"><i class="fa-solid fa-receipt"></i></div>
                            <span class="tl-desc">Đơn hàng đã được đặt</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>